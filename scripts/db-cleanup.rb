#!/bin/bash

# Auto summarization
echo "=== run auto summarization ==="
rails runner scripts/auto-summarizer/predictor/run-summarize.rb

# Clustering
echo "=== run clustering ==="
rails runner \
  scripts/personal-hotentry/tmp/predict-db-articles.rb | \
  sort -n > tmp/personal-hotentry/tmp/predicted-db-articles.txt

echo "=== add cluster ==="
rails runner \
  scripts/personal-hotentry/tmp/adding-user-articles.rb
