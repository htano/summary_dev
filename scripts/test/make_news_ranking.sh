#!/bin/bash

rm tmp/test_tweetstream.ongoing
cut -f1 tmp/user_url.txt | sort | uniq -c | sort -nr | perl -pe "s/^ +//" | perl -pe "s/ /\t/" > tmp/count_user.txt
sort tmp/user_url.txt > tmp/user_url_sort.txt
sort -k2 tmp/count_user.txt > tmp/count_user_sort.txt
join -1 1 -2 2 tmp/user_url_sort.txt tmp/count_user_sort.txt | sort -k3nr > tmp/user_url_count.txt
cat tmp/user_url_count.txt | awk '{print $0" "1/$3}' | cut -d" " -f2,4 > tmp/url_score.txt 
awk '{sums[$1] += $2} END { for (i in sums) printf("%s %s\n", i, sums[i])}' tmp/url_score.txt | sort -k2nr > tmp/url_score_uniq.txt 
rails runner scripts/test/add-articles-by-list.rb
