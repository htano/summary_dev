# encoding: utf-8
require './lib/article_classifier.rb'
require './lib/personal-hotentry.rb'

module MyDelayedJobs
  class MailingJob
    def initialize(user, auth_url)
      @user = user
      @auth_url = auth_url
    end

    def run
      Message.change_mail_addr(
        @user.name,
        @user.mail_addr,
        @auth_url
      ).deliver
    end
  end

  class ClassifyingJob
    def initialize(article_id)
      @article_id = article_id
    end

    def run
      ac_inst = ArticleClassifier.new
      ac_inst.read_models
      article = Article.find(@article_id)
      category_name = ac_inst.predict(article.title)
      category_id = Category.find_by_name(category_name).id
      article.category_id = category_id
      article.save
    end
  end

  class ClusteringJob
    def initialize(article_id)
      @article_id = article_id
    end

    def run
      article = Article.find(@article_id)
      ph_inst = PersonalHotentry.new
      cluster_id, cluster_score =
        ph_inst.predict_max_cluster_id(article.title)
      UserArticle.where(article_id: @article_id).each do |ua|
        ua.user.add_cluster_id(cluster_id)
      end
      article.cluster_id = cluster_id
      article.save
    end
  end
end
