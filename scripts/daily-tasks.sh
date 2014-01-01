#!/bin/bash
RAILS_ROOT=$1
cd ${RAILS_ROOT}

# make common daily data
rails runner scripts/daily-tasks/common/mklist-class-title-url.rb

# make document frequency
rails runner scripts/daily-tasks/text-analyzer/mkdf.rb

# add common daily data with tfidf
rails runner scripts/daily-tasks/common/mklist-class-title-url-tfidf.rb
