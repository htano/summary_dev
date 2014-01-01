#!/bin/bash
RAILS_ROOT=$1
R_ENV=$2
cd ${RAILS_ROOT}

# stop delayed_job
RAILS_ENV=${R_ENV} bin/delayed_job stop

# make common daily data
bin/rails runner scripts/daily-tasks/common/mklist-class-title-url.rb

# make document frequency
bin/rails runner scripts/daily-tasks/text-analyzer/mkdf.rb

# add common daily data with tfidf
bin/rails runner scripts/daily-tasks/common/mklist-class-title-url-tfidf.rb

# start delayed_job
RAILS_ENV=${R_ENV} bin/delayed_job start
