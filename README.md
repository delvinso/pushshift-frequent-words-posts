# pushshift-frequent-words-posts
Using Google Big Query and Pushshift to Analyze Occurences of Words in Titles of Reddit Submissions.

`1. query_noprojectname.R` contains the code used to query BigQuery for all reddit submissions and their titles from 2016 to 2018 October with more than 1000 upvotes. Requires authentication.

`2. analysis.R` contains code used for text mining and determining the top 20 most occuring words, and pairs of words in reddit submissions.

`3. helpers.R` contains theme helpers.

Resulting graphs can be found in `output/`.


