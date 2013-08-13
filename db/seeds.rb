# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# U010User
U010User.create(user_id: 1, user_name: "toru1055", mail_addr: "toru1055h@gmail.com", prof_image: "account_pictures/usertile44.bmp")
U010User.create(user_id: 2, user_name: "shingo0809", mail_addr: "shingo0809@gmail.com", prof_image: "account_pictures/usertile15.bmp")
U010User.create(user_id: 3, user_name: "yoshino023", mail_addr: "yoshino023@gmail.com", prof_image: "account_pictures/usertile14.bmp")
U010User.create(user_id: 4, user_name: "brynhildr", mail_addr: "brynhildr@gmail.com", prof_image: "account_pictures/usertile10.bmp")
U010User.create(user_id: 5, user_name: "eir", mail_addr: "eir@gmail.com", prof_image: "account_pictures/usertile11.bmp")
U010User.create(user_id: 6, user_name: "geirahoo", mail_addr: "geirahoo@gmail.com", prof_image: "account_pictures/usertile12.bmp")
U010User.create(user_id: 7, user_name: "geiravor", mail_addr: "geiravor@gmail.com", prof_image: "account_pictures/usertile13.bmp")
U010User.create(user_id: 8, user_name: "geirdriful", mail_addr: "geirdriful@gmail.com", prof_image: "account_pictures/usertile16.bmp")
U010User.create(user_id: 9, user_name: "herja", mail_addr: "herja@gmail.com", prof_image: "account_pictures/usertile17.bmp")
U010User.create(user_id: 10, user_name: "hildr", mail_addr: "hildr@gmail.com", prof_image: "account_pictures/usertile18.bmp")
U010User.create(user_id: 11, user_name: "kara", mail_addr: "kara@gmail.com", prof_image: "account_pictures/usertile19.bmp")
U010User.create(user_id: 12, user_name: "mist", mail_addr: "mist@gmail.com", prof_image: "account_pictures/usertile20.bmp")
U010User.create(user_id: 13, user_name: "qlrun", mail_addr: "qlrun@gmail.com", prof_image: "account_pictures/usertile21.bmp")
U010User.create(user_id: 14, user_name: "rota", mail_addr: "rota@gmail.com", prof_image: "account_pictures/usertile22.bmp")
U010User.create(user_id: 15, user_name: "sanngrior", mail_addr: "sanngrior@gmail.com", prof_image: "account_pictures/usertile23.bmp")
U010User.create(user_id: 16, user_name: "sigrun", mail_addr: "sigrun@gmail.com", prof_image: "account_pictures/usertile24.bmp")
U010User.create(user_id: 17, user_name: "svipul", mail_addr: "svipul@gmail.com", prof_image: "account_pictures/usertile25.bmp")
U010User.create(user_id: 18, user_name: "tanngnidr", mail_addr: "tanngnidr@gmail.com", prof_image: "account_pictures/usertile26.bmp")
U010User.create(user_id: 19, user_name: "pogn", mail_addr: "pogn@gmail.com", prof_image: "account_pictures/usertile27.bmp")
U010User.create(user_id: 20, user_name: "prima", mail_addr: "prima@gmail.com", prof_image: "account_pictures/usertile28.bmp")

# U011FavoriteUser
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 2)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 3)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 4)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 5)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 6)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 7)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 8)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 9)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 10)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 11)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 12)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 13)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 14)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 15)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 16)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 17)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 18)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 19)
U011FavoriteUser.create(u010_user_id: 1, favorite_user_id: 20)

# R010UserArticle
R010UserArticle.create(u010_user_id: 1, article_id:  1, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  2, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  3, read_flg: true)
R010UserArticle.create(u010_user_id: 1, article_id:  4, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  5, read_flg: true)
R010UserArticle.create(u010_user_id: 1, article_id:  6, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  7, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  8, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id:  9, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 10, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 11, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 12, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 13, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 14, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 15, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 16, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 17, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 18, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 19, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 20, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 21, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 22, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 23, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 24, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 25, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 26, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 27, read_flg: false)
R010UserArticle.create(u010_user_id: 1, article_id: 28, read_flg: false)

# A010Article
A010Article.create(article_id:  1, article_url: "http://www.yahoo.co.jp/",   article_title: "Yahoo! JAPAN")
A010Article.create(article_id:  2, article_url: "http://www.ibm.com/jp/ja/", article_title: "IBM - Japan")
A010Article.create(article_id:  3, article_url: "http://www.sony.co.jp/",article_title: "Sony Japan")
A010Article.create(article_id:  4, article_url: "https://www.google.com/?hl=ja", article_title: "Google")
A010Article.create(article_id:  5, article_url: "http://www.hatena.ne.jp/", article_title: "Hatena")
A010Article.create(article_id:  6, article_url: "http://www.waseda.jp/top/index-j.html", article_title: "Waseda")
A010Article.create(article_id:  7, article_url: "http://matome.naver.jp/odai/2133567381154336401",
  article_title: "インターネットのスタートページランキング - NAVER まとめ")
A010Article.create(article_id:  8, article_url: "http://matome.naver.jp/odai/2133423959853279401",
  article_title: "人気の英語学習系サイトまとめ - NAVER まとめ")
A010Article.create(article_id:  9, article_url: "http://matome.naver.jp/odai/2133548298340725301",
  article_title: "【渋谷】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 10, article_url: "http://matome.naver.jp/odai/2133384920831787301",
  article_title: "【銀座】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 11, article_url: "http://matome.naver.jp/odai/2133567114654151501",
  article_title: "【六本木】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 12, article_url: "http://matome.naver.jp/odai/2133561668251176901",
  article_title: "【新宿】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 13, article_url: "http://matome.naver.jp/odai/2133414646947595701",
  article_title: "人気観光地のお土産（お菓子）ランキング - NAVER まとめ")
A010Article.create(article_id: 14, article_url: "http://matome.naver.jp/odai/2133573867258693201",
  article_title: "【恵比寿】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 15, article_url: "http://matome.naver.jp/odai/2133597304178942101",
  article_title: "都内の合コン・デートで使える手ごろなお店シリーズ - NAVER まとめ")
A010Article.create(article_id: 16, article_url: "http://matome.naver.jp/odai/2136825569571531101",
  article_title: "くだらないAndroidアプリ - NAVER まとめ")
A010Article.create(article_id: 17, article_url: "http://matome.naver.jp/odai/2136723046118036501",
  article_title: "運動系ダイエットのランキング - NAVER まとめ")
A010Article.create(article_id: 18, article_url: "http://matome.naver.jp/odai/2136471979093845901",
  article_title: "六本木の家具・インテリアショップ - NAVER まとめ")
A010Article.create(article_id: 19, article_url: "http://matome.naver.jp/odai/2136472912296038801",
  article_title: "銀座の家具・インテリアショップ - NAVER まとめ")
A010Article.create(article_id: 20, article_url: "http://matome.naver.jp/odai/2136247985139182201",
  article_title: "【モテ男】になるための徹底マニュアル - NAVER まとめ")
A010Article.create(article_id: 21, article_url: "http://matome.naver.jp/odai/2133448503966734701",
  article_title: "機械学習系の記事・ブログ・連載 - NAVER まとめ")
A010Article.create(article_id: 22, article_url: "http://matome.naver.jp/odai/2133562135051562801",
  article_title: "【池袋】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 23, article_url: "http://matome.naver.jp/odai/2133547527140504201",
  article_title: "神谷町・御成門付近のおいしいお手ごろランチ - NAVER まとめ")
A010Article.create(article_id: 24, article_url: "http://matome.naver.jp/odai/2133606026884960501",
  article_title: "【表参道】合コン・デートに使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 25, article_url: "http://matome.naver.jp/odai/2133630953907832701",
  article_title: "【丸の内】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 26, article_url: "http://matome.naver.jp/odai/2137066521240736201",
  article_title: "アベノミクス期間の株価上昇率ランキング - NAVER まとめ")
A010Article.create(article_id: 27, article_url: "http://matome.naver.jp/odai/2133829297776209001",
  article_title: "【横浜駅】合コン・デートで使える手ごろなお店 - NAVER まとめ")
A010Article.create(article_id: 28, article_url: "http://matome.naver.jp/odai/2136353103939321201",
  article_title: "赤羽橋・三田付近のおいしいお手ごろランチ - NAVER まとめ")


# S010Summary
S010Summary.create(summary_id: 1, summary_content: "summary id 1 test", u010_user_id: 1, article_id: 1)
S010Summary.create(summary_id: 2, summary_content: "summary id 2 test", u010_user_id: 1, article_id: 2)
S010Summary.create(summary_id: 3, summary_content: "summary id 3 test", u010_user_id: 1, article_id: 3)
S010Summary.create(summary_id: 4, summary_content: "summary id 4 test", u010_user_id: 1, article_id: 4)
S010Summary.create(summary_id: 5, summary_content: "summary id 5 test", u010_user_id: 1, article_id: 5)
S010Summary.create(summary_id: 6, summary_content: "summary id 6 test", u010_user_id: 2, article_id: 1)
S010Summary.create(summary_id: 7, summary_content: "summary id 7 test", u010_user_id: 3, article_id: 1)
S010Summary.create(summary_id: 8, summary_content: "summary id 8 test", u010_user_id: 2, article_id: 2)

# S011GoodSummary
S011GoodSummary.create(user_id: 1, summary_id: 1)
S011GoodSummary.create(user_id: 1, summary_id: 1)
S011GoodSummary.create(user_id: 1, summary_id: 1)