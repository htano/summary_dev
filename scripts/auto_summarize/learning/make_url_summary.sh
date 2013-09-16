#!/bin/bash
RAILS_ROOT=/Users/thotta/git/summary_dev
SCRIPT_DIR=${RAILS_ROOT}/scripts/auto_summarize/learning
SCRIPT_PATH=${SCRIPT_DIR}/make_url_summary.rb
TMP_DIR=${RAILS_ROOT}/tmp/auto_summarize/learning
URL_LIST=${TMP_DIR}/url_list.txt
OUTPUT_DIR=${TMP_DIR}/url_summary

mkdir -p $OUTPUT_DIR
cd $RAILS_ROOT
idx=0
cat $URL_LIST | while read url_i
do
  URL=$url_i rails runner ${SCRIPT_PATH} > $OUTPUT_DIR/summary_url_${idx}.txt
  idx=`expr $idx + 1`
done
