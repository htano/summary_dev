#!/bin/bash
RAILS_ROOT=/Users/thotta/git/summary_dev
SCRIPT_DIR=${RAILS_ROOT}/scripts/auto_summarize/learning
SCRIPT_PATH=${SCRIPT_DIR}/convert_url2contents.rb
TMP_DIR=${RAILS_ROOT}/tmp/auto_summarize/learning
INPUT_DIR=${TMP_DIR}/url_summary
OUTPUT_DIR=${TMP_DIR}/url_summary_contents

mkdir -p $OUTPUT_DIR
cd $RAILS_ROOT

idx=0
ls $INPUT_DIR | while read url_summary_file
do
  url_i=`head -1 $INPUT_DIR/$url_summary_file`
  URL=$url_i rails runner $SCRIPT_PATH > $OUTPUT_DIR/train_data_${idx}.txt
  tail -1 $INPUT_DIR/$url_summary_file >> $OUTPUT_DIR/train_data_${idx}.txt
  idx=`expr $idx + 1`
done
