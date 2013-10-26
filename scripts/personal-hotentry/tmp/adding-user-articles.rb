# coding: utf-8
User.all.each do |u|
  u.cluster_vector = nil
  u.save
  u.user_articles.order(
    'created_at'
  ).each do |ua|
    puts u.name + " : " + ua.article.title
    u.add_cluster_id(ua.article.cluster_id)
  end
end
