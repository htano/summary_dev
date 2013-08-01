# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# U010User
U010User.create(user_id: 1, user_name: "toru1055", mail_addr: "toru1055h@gmail.com")
U010User.create(user_id: 2, user_name: "shingo0809", mail_addr: "shingo0809@gmail.com")
U010User.create(user_id: 3, user_name: "yoshino023", mail_addr: "yoshino023@gmail.com")

# R010UserArticle
R010UserArticle.create(user_id: 1, article_id: 1, read_flg: false)
R010UserArticle.create(user_id: 1, article_id: 2, read_flg: false)
R010UserArticle.create(user_id: 1, article_id: 3, read_flg: true)
R010UserArticle.create(user_id: 1, article_id: 4, read_flg: false)
R010UserArticle.create(user_id: 1, article_id: 5, read_flg: true)
R010UserArticle.create(user_id: 1, article_id: 6, read_flg: false)

# A010Article
A010Article.create(article_id: 1, article_url: "http://www.yahoo.co.jp/",   article_title: "Yahoo! JAPAN")
A010Article.create(article_id: 2, article_url: "http://www.ibm.com/jp/ja/", article_title: "IBM - Japan")
A010Article.create(article_id: 3, article_url: "http://www.sony.co.jp/",article_title: "Sony Japan")
A010Article.create(article_id: 4, article_url: "https://www.google.com/?hl=ja", article_title: "Google")
A010Article.create(article_id: 5, article_url: "http://www.hatena.ne.jp/", article_title: "Hatena")
A010Article.create(article_id: 6, article_url: "http://www.waseda.jp/top/index-j.html", article_title: "Waseda")
A010Article.create(article_id: 7, article_url: "https://www.facebook.com/", article_title: "Facebook")

# S010Summary
S010Summary.create(summary_id: 1, summary_content: "summary id 1 test", user_id: 1, article_id: 1)
S010Summary.create(summary_id: 2, summary_content: "summary id 2 test", user_id: 1, article_id: 2)
S010Summary.create(summary_id: 3, summary_content: "summary id 3 test", user_id: 1, article_id: 3)
S010Summary.create(summary_id: 4, summary_content: "summary id 4 test", user_id: 1, article_id: 4)
S010Summary.create(summary_id: 5, summary_content: "summary id 5 test", user_id: 1, article_id: 5)

