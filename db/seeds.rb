# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User
User.create(name: "summary", mail_addr: "summary.dev@gmail.com",
  open_id: "https://www.google.com/accounts/o8/id?id=AItOawn4ayi4TWTPrWFO_XzWCp_uX5J_pZ6TVVU",
  prof_image: "account_pictures/usertile44.bmp", yuko_flg: true, public_flg: true)
User.create(name: "shingo0809", mail_addr: "shingo0809@gmail.com", open_id:"openid",
  prof_image: "account_pictures/usertile15.bmp", public_flg: true)
User.create(name: "yoshino023", mail_addr: "yoshino023@gmail.com", open_id:"openid1",
  prof_image: "account_pictures/usertile14.bmp", public_flg: true)
User.create(name: "brynhildr", mail_addr: "brynhildr@gmail.com", open_id:"openid2",
  prof_image: "account_pictures/usertile10.bmp")
User.create(name: "eir", mail_addr: "eir@gmail.com", open_id:"openid3",
  prof_image: "account_pictures/usertile11.bmp")
User.create(name: "geirahoo", mail_addr: "geirahoo@gmail.com", open_id:"openid4",
  prof_image: "account_pictures/usertile12.bmp")
User.create(name: "geiravor", mail_addr: "geiravor@gmail.com", open_id:"openid5",
  prof_image: "account_pictures/usertile13.bmp")
User.create(name: "geirdriful", mail_addr: "geirdriful@gmail.com", open_id:"openid6",
  prof_image: "account_pictures/usertile16.bmp", public_flg: true)
User.create(name: "herja", mail_addr: "herja@gmail.com", open_id:"openid7",
  prof_image: "account_pictures/usertile17.bmp")
User.create(name: "hildr", mail_addr: "hildr@gmail.com", open_id:"openid8",
  prof_image: "account_pictures/usertile18.bmp")
User.create(name: "kara", mail_addr: "kara@gmail.com", open_id:"openid9",
  prof_image: "account_pictures/usertile19.bmp")
User.create(name: "mist", mail_addr: "mist@gmail.com", open_id:"openid10",
  prof_image: "account_pictures/usertile20.bmp")
User.create(name: "qlrun", mail_addr: "qlrun@gmail.com", open_id:"openid11",
  prof_image: "account_pictures/usertile21.bmp", public_flg: true)
User.create(name: "rota", mail_addr: "rota@gmail.com", open_id:"openid12",
  prof_image: "account_pictures/usertile22.bmp", public_flg: true)
User.create(name: "sanngrior", mail_addr: "sanngrior@gmail.com", open_id:"openid13",
  prof_image: "account_pictures/usertile23.bmp")
User.create(name: "sigrun", mail_addr: "sigrun@gmail.com", open_id:"openid14",
  prof_image: "account_pictures/usertile24.bmp")
User.create(name: "svipul", mail_addr: "svipul@gmail.com", open_id:"openid15",
  prof_image: "account_pictures/usertile25.bmp", public_flg: true)
User.create(name: "tanngnidr", mail_addr: "tanngnidr@4mail.com", open_id:"openid16",
  prof_image: "account_pictures/usertile26.bmp", public_flg: true)
User.create(name: "pogn", mail_addr: "pogn@gmail.com", open_id:"openid17",
  prof_image: "account_pictures/usertile27.bmp")
User.create(name: "prima", mail_addr: "prima@gmail.com", open_id:"openid18",
  prof_image: "account_pictures/usertile28.bmp", public_flg: true)
User.create(name: "system001", mail_addr: "system001@gmail.com", open_id:"openid001", public_flg: true)

# FavoriteUser
FavoriteUser.create(user_id: 1, favorite_user_id: 2)
FavoriteUser.create(user_id: 1, favorite_user_id: 3)
FavoriteUser.create(user_id: 1, favorite_user_id: 4)
FavoriteUser.create(user_id: 1, favorite_user_id: 5)
FavoriteUser.create(user_id: 1, favorite_user_id: 6)
FavoriteUser.create(user_id: 1, favorite_user_id: 7)
FavoriteUser.create(user_id: 1, favorite_user_id: 8)
FavoriteUser.create(user_id: 1, favorite_user_id: 9)
FavoriteUser.create(user_id: 1, favorite_user_id: 10)
FavoriteUser.create(user_id: 1, favorite_user_id: 11)
FavoriteUser.create(user_id: 1, favorite_user_id: 12)
FavoriteUser.create(user_id: 1, favorite_user_id: 13)
FavoriteUser.create(user_id: 1, favorite_user_id: 14)
FavoriteUser.create(user_id: 1, favorite_user_id: 15)
FavoriteUser.create(user_id: 1, favorite_user_id: 16)
FavoriteUser.create(user_id: 1, favorite_user_id: 17)
FavoriteUser.create(user_id: 1, favorite_user_id: 18)
FavoriteUser.create(user_id: 1, favorite_user_id: 19)
FavoriteUser.create(user_id: 1, favorite_user_id: 20)
FavoriteUser.create(user_id: 2, favorite_user_id: 1)
FavoriteUser.create(user_id: 2, favorite_user_id: 3)
FavoriteUser.create(user_id: 2, favorite_user_id: 4)
FavoriteUser.create(user_id: 2, favorite_user_id: 5)
FavoriteUser.create(user_id: 2, favorite_user_id: 6)
FavoriteUser.create(user_id: 2, favorite_user_id: 7)
FavoriteUser.create(user_id: 2, favorite_user_id: 8)
FavoriteUser.create(user_id: 3, favorite_user_id: 1)
FavoriteUser.create(user_id: 3, favorite_user_id: 2)
FavoriteUser.create(user_id: 3, favorite_user_id: 4)
FavoriteUser.create(user_id: 3, favorite_user_id: 5)
FavoriteUser.create(user_id: 3, favorite_user_id: 6)
FavoriteUser.create(user_id: 4, favorite_user_id: 1)
FavoriteUser.create(user_id: 4, favorite_user_id: 5)
FavoriteUser.create(user_id: 4, favorite_user_id: 6)
FavoriteUser.create(user_id: 4, favorite_user_id: 7)
FavoriteUser.create(user_id: 4, favorite_user_id: 8)
FavoriteUser.create(user_id: 4, favorite_user_id: 9)
FavoriteUser.create(user_id: 4, favorite_user_id: 10)
FavoriteUser.create(user_id: 5, favorite_user_id: 1)
FavoriteUser.create(user_id: 13, favorite_user_id: 1)
FavoriteUser.create(user_id: 14, favorite_user_id: 1)
FavoriteUser.create(user_id: 15, favorite_user_id: 1)
FavoriteUser.create(user_id: 16, favorite_user_id: 1)
FavoriteUser.create(user_id: 17, favorite_user_id: 1)
FavoriteUser.create(user_id: 18, favorite_user_id: 1)
FavoriteUser.create(user_id: 19, favorite_user_id: 1)
FavoriteUser.create(user_id: 20, favorite_user_id: 1)

# UserArticle
UserArticle.create(user_id: 1, article_id:  1, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id:  2, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id:  3, read_flg: true)
UserArticle.create(user_id: 1, article_id:  4, read_flg: false)
UserArticle.create(user_id: 1, article_id:  5, read_flg: true, favorite_flg: true)
UserArticle.create(user_id: 1, article_id:  6, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id:  7, read_flg: false)
UserArticle.create(user_id: 1, article_id:  8, read_flg: false)
UserArticle.create(user_id: 1, article_id:  9, read_flg: false)
UserArticle.create(user_id: 1, article_id: 10, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id: 11, read_flg: false)
UserArticle.create(user_id: 1, article_id: 12, read_flg: false)
UserArticle.create(user_id: 1, article_id: 13, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id: 14, read_flg: false)
UserArticle.create(user_id: 1, article_id: 15, read_flg: false)
UserArticle.create(user_id: 1, article_id: 16, read_flg: false)
UserArticle.create(user_id: 1, article_id: 17, read_flg: false)
UserArticle.create(user_id: 1, article_id: 18, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id: 19, read_flg: false)
UserArticle.create(user_id: 1, article_id: 20, read_flg: false)
UserArticle.create(user_id: 1, article_id: 21, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id: 22, read_flg: false)
UserArticle.create(user_id: 1, article_id: 23, read_flg: false)
UserArticle.create(user_id: 1, article_id: 24, read_flg: false)
UserArticle.create(user_id: 1, article_id: 25, read_flg: false, favorite_flg: true)
UserArticle.create(user_id: 1, article_id: 26, read_flg: false)
UserArticle.create(user_id: 1, article_id: 27, read_flg: false)
UserArticle.create(user_id: 1, article_id: 28, read_flg: false)


# Article
Article.create(url: "http://www.yahoo.co.jp/", title: "Yahoo! JAPAN")
Article.create(url: "http://www.ibm.com/jp/ja/", title: "IBM - Japan")
Article.create(url: "http://www.sony.co.jp/", title: "Sony Japan")
Article.create(url: "https://www.google.com/?hl=ja", title: "Google")
Article.create(url: "http://www.hatena.ne.jp/", title: "Hatena")
Article.create(url: "http://www.waseda.jp/top/index-j.html", title: "Waseda")
Article.create(url: "http://matome.naver.jp/odai/2133567381154336401", 
  title: "インターネットのスタートページランキング - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133423959853279401",
  title: "人気の英語学習系サイトまとめ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133548298340725301",
  title: "【渋谷】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133384920831787301",
  title: "【銀座】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133567114654151501",
  title: "【六本木】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133561668251176901",
  title: "【新宿】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133414646947595701",
  title: "人気観光地のお土産（お菓子）ランキング - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133573867258693201",
  title: "【恵比寿】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133597304178942101",
  title: "都内の合コン・デートで使える手ごろなお店シリーズ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136825569571531101",
  title: "くだらないAndroidアプリ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136723046118036501",
  title: "運動系ダイエットのランキング - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136471979093845901",
  title: "六本木の家具・インテリアショップ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136472912296038801",
  title: "銀座の家具・インテリアショップ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136247985139182201",
  title: "【モテ男】になるための徹底マニュアル - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133448503966734701",
  title: "機械学習系の記事・ブログ・連載 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133562135051562801",
  title: "【池袋】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133547527140504201",
  title: "神谷町・御成門付近のおいしいお手ごろランチ - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133606026884960501",
  title: "【表参道】合コン・デートに使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133630953907832701",
  title: "【丸の内】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2137066521240736201",
  title: "アベノミクス期間の株価上昇率ランキング - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2133829297776209001",
  title: "【横浜駅】合コン・デートで使える手ごろなお店 - NAVER まとめ")
Article.create(url: "http://matome.naver.jp/odai/2136353103939321201",
  title: "赤羽橋・三田付近のおいしいお手ごろランチ - NAVER まとめ")


# Summary
Summary.create(content: "summary id 1 test", user_id: 1, article_id: 1)
Summary.create(content: "summary id 2 test", user_id: 1, article_id: 2)
Summary.create(content: "summary id 3 test", user_id: 4, article_id: 3)
Summary.create(content: "summary id 4 test", user_id: 3, article_id: 4)
Summary.create(content: "summary id 5 test", user_id: 1, article_id: 5)
Summary.create(content: "summary id 6 test", user_id: 2, article_id: 1)
Summary.create(content: "summary id 7 test", user_id: 3, article_id: 1)
Summary.create(content: "summary id 8 test", user_id: 2, article_id: 2)

# GoodSummary
GoodSummary.create(user_id: 1, summary_id: 1)
GoodSummary.create(user_id: 2, summary_id: 1)
GoodSummary.create(user_id: 3, summary_id: 1)
GoodSummary.create(user_id: 4, summary_id: 1)
GoodSummary.create(user_id: 5, summary_id: 1)
GoodSummary.create(user_id: 3, summary_id: 2)
GoodSummary.create(user_id: 2, summary_id: 2)
GoodSummary.create(user_id: 4, summary_id: 2)
GoodSummary.create(user_id: 3, summary_id: 3)
GoodSummary.create(user_id: 3, summary_id: 4)
GoodSummary.create(user_id: 4, summary_id: 4)
GoodSummary.create(user_id: 2, summary_id: 5)
