# encoding: utf-8
require './lib/article_classifier.rb'
require './lib/personal-hotentry.rb'
require './lib/auto-summary.rb'

module MyDelayedJobs
  class SummarizingJob
    include AutoSummary

    def initialize(article_id)
      @article_id = article_id
    end

    def run
      summarizer = Summarizer.new
      article = Article.find(@article_id)
      user = User.find_by_name(AUTO_SUMMARIZER_NAME)
      if article && user
        unless article.summaries.find_by_user_id(user.id)
          if article.auto_summary_error_status
            Rails.logger.info(
              "This page has invalid status: " +
              article.auto_summary_error_status +
              ", ArticleId: " + article.id.to_s
            )
          else
            summary_contents, error_status = 
              summarizer.run(article.url)
            if error_status
              article.auto_summary_error_status = error_status
              article.save
            else
              Summary.create(
                :content => summary_contents, 
                :user_id => user.id, 
                :article_id => article.id
              )
            end
          end
        end
      else
        Rails.logger.error(AUTO_SUMMARIZER_NAME +
                           " is not exists.")
      end
    end
  end

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
