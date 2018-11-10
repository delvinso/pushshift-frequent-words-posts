library(tidyverse)
library(bigrquery)


project_name <- 'YOUR_PROJECT_HERE'

# https://bigquery.cloud.google.com/dataset/fh-bigquery:reddit_posts

# 2016 ----
year_months_2016 <- paste(2016, c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11","12"), sep = "_")
year_months_2016 


posts_2016 <- year_months_2016  %>% map(~  
                                          paste0("SELECT title, subreddit, author, num_comments, SEC_TO_TIMESTAMP(created_utc) AS date, score FROM [fh-bigquery.reddit_posts.", .x, "] WHERE score > 1000") %>% 
                                          query_exec(., project = project_name, max_pages = Inf))

# could use map_dfr() but map returns a list which personally makes it easier to see if any of the individual
# elements went wrong.
posts_2016 %>% bind_rows() %>% tbl_df() %>% write_csv("submission_titles_2016.csv")

# 2017 ---
year_months <- c("2017_01", "2017_02", "2017_03", "2017_04", "2017_05", "2017_06", "2017_07", "2017_08", "2017_09",
  "2017_10", "2017_11", "2017_12") 

posts_2017 <- year_months %>% map(~  
        paste0("SELECT title, subreddit, author, num_comments, SEC_TO_TIMESTAMP(created_utc) AS date, score FROM [fh-bigquery.reddit_posts.", .x, "] WHERE score > 1000") %>% 
          query_exec(., project = project_name, max_pages = Inf))

# could use map_dfr() but map returns a list which personally makes it easier to see if any of the individual
# elements went wrong.
posts_2017 %>% bind_rows() %>% tbl_df() %>% write_csv("submission_titles_2017.csv")


# 2018 thus far ----

year_months_2018_to_sept <- c("2018_01", "2018_02", "2018_03", "2018_04", "2018_05", "2018_06", "2018_07", "2018_08", "2018_09")
                 #"2018_10")#, "2018_11", "2017_12") 

posts_2018 <- year_months_2018_to_sept %>% map(~  
                                          paste0("SELECT title, subreddit, author, num_comments, SEC_TO_TIMESTAMP(created_utc) AS date, score FROM [fh-bigquery.reddit_posts.", .x, "] WHERE score > 1000") %>% 
                                            query_exec(., project = project_name, max_pages = Inf))

# could use map_dfr() but map returns a list which personally makes it easier to see if any of the individual
# elements went wrong.
posts_2018 %>% bind_rows() %>% tbl_df() %>% write_csv("submission_titles_2018.csv")


# using a single month ----
# check quota used
sql <- ("
        SELECT title, subreddit, SEC_TO_TIMESTAMP(created_utc) as date, score FROM 
       [fh-bigquery.reddit_posts.2017_02] WHERE score > 1000 AND")
df <- tbl_df(bg_projectquery_exec(sql, project=project_name, max_pages = Inf))
df 

