#!/bin/sh

num=0
main_user_id=1

output_data() {
  echo "favorite_user_data$1:"
  echo "    id: $1"
  echo "    user_id: $2"
  echo "    favorite_user_id: $3"
}

while [ $num -lt 30 ]
do
  num=`expr ${num} + 1`
  id=`expr ${num} + 1`
  output_data ${num} ${id} ${main_user_id}
done

id=1
while [ $num -lt 60 ]
do
  num=`expr ${num} + 1`
  id=`expr ${id} + 1`
  output_data ${num} ${main_user_id} ${id}
done
