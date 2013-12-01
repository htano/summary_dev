# encoding: utf-8
require './lib/contents-extractor.rb'
require './lib/article_classifier.rb'
require './lib/personal-hotentry.rb'
require './lib/auto-summary.rb'

module MyDelayedJobs
  class PreviewingJob
    include ContentsExtractor
    def initialize(article_id)
      @article_id = article_id
    end

    def run
      ext_factory = ExtractorFactory.instance
      a= Article.find(@article_id)
      c_ext= ext_factory.new_extractor(a.url)
      if a.html
        if c_ext.analyze!(a.html)
          a.contents_preview = c_ext.get_body_text[0,200]
          a.save
        end
      end
    end
  end

  class ThumbnailingJob
    THRESHOLD_FILE = 100
    THRESHOLD_IMAGE = 150
    ADVERTISEMENT_LIST = [
      "amazon",
      "rakuten",
      "bannar",
      "Bannar"
    ]
    EXCEPTION_PAGE_LIST = [
      "http://g-ec2.images-amazon.com/images/G/09/gno/beacon/BeaconSprite-JP-02._V393500380_.png"
    ]
    def initialize(article_id)
      @article_id = article_id
    end

    def run
      a= Article.find(@article_id)
      a.thumbnail = get_image_url(a)
      a.save
    end

    private
    def isAdvertisement?(img_url)
      ADVERTISEMENT_LIST.each do |adv|
        if img_url.include?(adv)
          return true
        end
      end
      return false
    end

    def isExceptionImage?(img_url)
      EXCEPTION_PAGE_LIST.each do |exception_page|
        if img_url == exception_page
          return true
        end
      end
      return false
    end

    def get_image_url(a)
      img_url = nil
      doc = Nokogiri::HTML.parse(a.html)
      doc.xpath("//img").each do |img|
        img_url = img["src"]
        next if img_url == nil or img_url == ""
        next if isAdvertisement?(img_url)
        next if isExceptionImage?(img_url)
        unless img_url.start_with?("http")
          img_url = URI.join(a.url, img_url).to_s
        end
        begin
          file = ImageSize.new(open(img_url, "rb").read)
        rescue => e
          Rails.logger.info("[Info@get_image_url] ImageSize:#{e}")
          next
        end
        if file.get_width && file.get_height
          if(file.get_width > THRESHOLD_FILE &&
             file.get_height > THRESHOLD_FILE)
            return img_url
          else
            next
          end
        end
        begin
          image = Magick::ImageList.new(img_url)
        rescue => e
          Rails.logger.info("[Info@get_image_url] Magick:#{e}")
          next
        end
        if(image.columns.to_i > THRESHOLD_IMAGE &&
           image.rows.to_i > THRESHOLD_IMAGE)
          return img_url
        end
      end
      return "no_image.png"
    end
  end

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
              summarizer.run(article.url, article.html)
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
      contents = article.get_contents_text
      category_name = ac_inst.predict(contents)
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
      contents = article.get_contents_text
      cluster_id, cluster_score =
        ph_inst.predict_max_cluster_id(contents)
      UserArticle.where(article_id: @article_id).each do |ua|
        ua.user.add_cluster_id(cluster_id)
      end
      article.cluster_id = cluster_id
      article.save
    end
  end
end
