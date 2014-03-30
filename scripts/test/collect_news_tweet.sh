#!/bin/bash
RAILS_ROOT=$1
BINDIR=$2
R_ENV=$3
cd ${RAILS_ROOT}

${BINDIR}/rails runner scripts/test/test_tweetstream_from_list.rb > tmp/user_url.txt -e ${R_ENV}
