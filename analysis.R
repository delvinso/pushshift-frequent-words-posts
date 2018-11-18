library(tidytext)
library(tidyverse)
library(scales)

# infiles <- list.files(path = "data", full.names = TRUE)

# posts <- infiles %>% map_dfr(~ read_csv(.x) %>% 
#                       mutate(year =  as.numeric(gsub(".*?([0-9]+).*", "\\1", .x))))

posts <- read_csv("data/posts_2016_to_2018.csv")

# tokenizing into single words
  # tokenizing titles
  posts_words <- posts %>% 
    group_by(post_id = row_number()) %>% 
    unnest_tokens(word, title)
  
  # removing stop words and counting the number of words by year
  posts_word_count <- posts_words %>% 
    anti_join(stop_words) %>%
    filter(!word %in% c("1", "2", "3", "amp", "post", "game", "match")) %>% 
    group_by(year) %>% 
    count(word, sort = TRUE)
  
  posts_word_top_20 <- posts_word_count %>% 
    group_by(year) %>%
    # mutate(proportion = prop.table(n)) %>%
    mutate(total_words = sum(n), proportion = n/total_words) %>% 
    top_n(20) %>% ungroup()

png(filename = "output/top_20_words_titles_by_year.png", width = 800, height = 600)
  posts_word_top_20 %>%
    mutate(year = paste0(year, "\n total words: ", comma(total_words))) %>% 
    # mutate(proportion = prop.table(n)) %>%
    ggplot(aes(x = reorder(word, proportion), y = proportion, fill = n)) +
      geom_label(aes(label = scales::percent(proportion)), hjust = -0.025) + 
      geom_col() + 
      coord_flip() + 
      theme_dark_ds(base_size = 16) + 
      # scale_fill_viridis_c("") +
      scale_fill_distiller(palette = "Spectral") + 
      # scale_y_continuous(labels = percent, limits = c(0, 0.22)) +
    scale_y_continuous(labels = percent, limits = c(0, 0.0115)) +
    
      # scale_fill_brewer(palette = "Dark2") + 
      ggtitle("Top 20 Occuring Words in Titles of Reddit Submissions (> 1000 Upvotes)", "2016 - 2018 September") +
      labs(x = "", y = "Percent of Total Words", caption = "delvinso.github.io") +
     # labs(x = "", y = "Percent of Total Words") +
    
      guides(fill = FALSE) +
      facet_wrap(~ year, scales = "free_y")#, labeller = label_wrap_gen())
dev.off()
# tokenizing into bigrams
misc_words <- c("amp", "post", "game", "match")

posts_bigrams <- posts %>%
  unnest_tokens(word, title, token = "ngrams", n = 2) %>%
  separate(word, c("word1", "word2")) %>%
  filter(!word1 %in% c(stop_words$word, misc_words), !word2 %in% c(stop_words$word, misc_words),
         !str_detect(word1, "[0-9]+"), !str_detect(word2, "[0-9]+")) %>%
  na.omit() %>% 
  unite(bigram, c(word1, word2), sep = " ")

posts_bigrams_count <- posts_bigrams %>%
  group_by(year) %>%
  count(bigram, sort = TRUE)

posts_bigrams_top_20 <- posts_bigrams_count %>% 
  group_by(year) %>%
  mutate(total_words = sum(n), proportion = n/total_words) %>% 
  top_n(20) %>% ungroup()
png(filename = "output/top_20_bigrams_titles_by_year.png", width = 800, height = 600)
posts_bigrams_top_20 %>% 
  mutate(year = paste0(year, " \ntotal bigrams: ", comma(total_words))) %>% 
  # mutate(proportion = as.numeric(formatC(proportion, digits = 4, format = "f"))) %>% 
  # mutate(proportion = prop.table(n)) %>%
  ggplot(aes(x = reorder(bigram, proportion), y = proportion, fill = n)) +
  geom_label(aes(label = scales::percent(proportion)), hjust = -0.025) + 
  geom_col() + 
  coord_flip() + 
  theme_dark_ds(base_size = 14) + 
  # scale_fill_viridis_c("") +
  scale_fill_distiller(palette = "Spectral") + 
  scale_y_continuous(labels = percent, limits = c(0, 0.008)) +
  # scale_y_continuous("Percent of Total Bigrams", labels = function(x) paste0(sprintf("%000.0f", x*100),"%")) +
  # scale_fill_brewer(palette = "Dark2") + 
  ggtitle("Top 20 Occuring Pairs of Words in Titles of Reddit Submissions (> 1000 Upvotes)", "2016 - 2018 September") +
  labs(x = "", y = "Percent of Total Bigrams", caption = "delvinso.github.io") +
  # labs(x = "",  y = "Percent of Total Bigrams") +
  
  guides(fill = FALSE) +
  facet_wrap(~ year, scales = "free_y")#, labeller = label_wrap_gen())
dev.off()

## posts by hour
library(lubridate)
posts_dow_hour <- posts %>%
  mutate(weekday = weekdays(date), hour = hour(date),
         weekday = factor(weekday, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))) %>%
  # group_by(year) %>% 
  count(weekday, hour)

posts_dow_hour %>%
  ggplot(aes(y = weekday, x = hour)) + 
  geom_tile(aes(fill = n), alpha = 0.8) + 
  theme_dark_ds(base_size = 16) + 
  scale_fill_viridis_c() +
  theme(legend.position = "top",
        legend.direction = "horizontal") + 
  # facet_wrap(~ year, nrow = 3) + 
  coord_equal()
