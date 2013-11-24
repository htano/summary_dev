#!/bin/sh

id=0

output_data() {
    echo "user_articles_$1:"
    echo "    id: $1"
    echo "    user_id: $2"
    echo "    article_id: $3"
    echo "    read_flg: $4"
    echo "    favorite_flg: $5"
}

create_one_user() {
    user_id=$1

    for i in `seq 0 25`
    do
	id=`expr $id + 1`
	base_num=`expr $i + $user_id`
	article_id=`expr $base_num \* 2`

	if [ `expr $i % 2` == 0 ]; then
	    read_flg="true"
	else
	    read_flg="false"
	fi

	if [ `expr $i % 3` == 0 ]; then
	    favorite_flg="true"
	else
	    favorite_flg="false"
	fi
	output_data $id $user_id $article_id $read_flg $favorite_flg
    done
}

create_one_user 1
create_one_user 2
create_one_user 10
create_one_user 20
create_one_user 25

