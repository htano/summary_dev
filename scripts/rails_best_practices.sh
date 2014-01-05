#!/bin/sh

OUTDIR=reports
TMPFILE=$OUTDIR/rails_best_practices.tmp
OUTFILE=$OUTDIR/rails_best_practices.properties

cd `dirname $0`/..
mkdir $OUTDIR 2> /dev/null
bundle exec rails_best_practices > $TMPFILE

STATUS=$?

if [ $STATUS -eq 0 ]; then
  echo "YVALUE=0" > $OUTFILE
else
  NUM=`awk '/^Found [0-9]+/{ print $2;}' < $TMPFILE`
  echo "YVALUE=$NUM" > $OUTFILE
fi
