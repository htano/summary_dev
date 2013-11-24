#!/bin/sh
[ -f $1 ] || exit 1

output_data() {
    id=$1
    name=$2
    oauth=$3
    open_id=$4

    echo "user${id}:"
    echo "    id: ${id}"
    echo "    name: \"${name}\""
    echo "    mail_addr: \"${name}@summary.dev\""
    echo "    yuko_flg: true"
    echo "    open_id: \"oauth://${oauth}/${open_id}\""
    echo "    prof_image: \"no_image.png\""
    echo "    full_name: \"${name}_dev\""
    echo "    comment: \"\""
}

i=0
open_id=12345
while read line
do
    i=`expr $i + 1`
    data=($line)
    name1=${data[1]}

    output_data ${i} ${name1} "twitter" ${open_id}
    open_id=`expr $open_id + 1`

    i=`expr $i + 1`
    name2=${data[3]}

    output_data ${i} ${name2} "facebook" ${open_id}
    open_id=`expr $open_id + 1`
done < $1
