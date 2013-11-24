#!/bin/sh

output_data() {
    echo "good_summaries$1:"
    echo "    id: $1"
    echo "    user_id: $2"
    echo "    summary_id : $3"
}

id=0
for j in `seq 0 5`
do
    for i in `seq 0 10`
    do
	id=`expr $id + 1`
	user_id=`expr $j + 1`
	summary_id=`expr $i + 1`
	output_data $id $user_id $summary_id
    done
done

