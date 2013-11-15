#!/bin/bash

# For article classifier
echo "== making article classifier data ==="
mkdir -p tmp/article_classifier/learning/`date "+%Y%m%d"`
rails runner scripts/article_classifier/learning/get_titles_with_class.rb > \
  tmp/article_classifier/learning/`date "+%Y%m%d"`/title_with_class.txt

# For bayon train data create
echo "=== making data for article clustering ==="
rails runner scripts/personal-hotentry/tmp/get_title_url.rb > \
  tmp/personal-hotentry/tmp/title-url-`date "+%Y%m%d"`.txt
cp tmp/personal-hotentry/tmp/title-url-`date "+%Y%m%d"`.txt \
  tmp/personal-hotentry/tmp/title-url.txt
rails runner \
  scripts/personal-hotentry/tmp/bayon-data-creator-by-url-list.rb > \
  tmp/personal-hotentry/tmp/bayon-train-`date "+%Y%m%d"`.txt

# For testing
echo "=== making test data from url-list ==="
rails runner scripts/personal-hotentry/tmp/add-articles-by-list.rb

# Auto summarization
echo "=== run auto summarization ==="
rails runner scripts/auto-summarizer/predictor/run-summarize.rb
