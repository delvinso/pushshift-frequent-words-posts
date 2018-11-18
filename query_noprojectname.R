library(tidyverse)
library(bigrquery)


billing <- 'YOUR_PROJECT_HERE'

# https://bigquery.cloud.google.com/dataset/fh-bigquery:reddit_posts

# query for all titles made after 2016 (technically between 2016 and 2018 September), with a score greater than 1000

sql <-"
#standardSQL
SELECT title, subreddit, 
              date(timestamp_seconds(created_utc)) AS date, 
              format_date('%Y', date(timestamp_seconds(created_utc))) AS year, 
              ID as id 
        FROM `fh-bigquery.reddit_posts.20*`
          WHERE _TABLE_SUFFIX > '16'
          AND score > 1000
"
posts <-  bq_project_query(billing, sql, use_legacy_sql = FALSE) %>% 
  bq_table_download(., max_results = Inf)

posts %>% write_csv("data/posts_2016_to_2018.csv")
