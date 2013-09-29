#!/bin/bash
SCRIPT_L=scripts/auto_summarize/learning
SCRIPT_P=scripts/auto_summarize/predict
TMP_L=tmp/auto_summarize/learning
WORK_DATE=`date +"%Y%m%d"`

echo "== make_urllist_for_traindata =="
rails runner ${SCRIPT_L}/make_urllist_for_traindata.rb > ${TMP_L}/url_list.txt
echo "== make_url_summary =="
sh ${SCRIPT_L}/make_url_summary.sh
echo "== convert_url2contents =="
sh ${SCRIPT_L}/convert_url2contents.sh
echo "== make_idf_dict =="
ruby ${SCRIPT_L}/make_idf_dict.rb > ${TMP_L}/dict/idf_dict.txt
cp ${TMP_L}/dict/idf_dict.txt ${SCRIPT_P}/dict/idf_dict.txt
echo "== make_liblinear =="
ruby ${SCRIPT_L}/make_liblinear.rb > ${TMP_L}/train_data.txt
echo "== run_liblinear_learning =="
R --vanilla --slave < scripts/auto_summarize/learning/run_liblinear_learning.r
