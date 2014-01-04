#!/bin/bash
RAILS_ROOT=$1
BINDIR=$2
R_ENV=$3
cd ${RAILS_ROOT}

# stop delayed_job
RAILS_ENV=${R_ENV} ${BINDIR}/bundle exec bin/delayed_job stop

# make common daily data
${BINDIR}/rails runner scripts/daily-tasks/common/mklist-class-title-url.rb

# make document frequency
${BINDIR}/rails runner scripts/daily-tasks/text-analyzer/mkdf.rb

# add common daily data with tfidf
${BINDIR}/rails runner scripts/daily-tasks/common/mklist-class-title-url-tfidf.rb

# start delayed_job
RAILS_ENV=${R_ENV} ${BINDIR}/bundle exec bin/delayed_job start
