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
      a= Article.find(@article_id)
      ext_factory = ExtractorFactory.instance
      c_ext = ext_factory.new_extractor(a.url)
      html = c_ext.openurl_wrapper(a.url)
      if html
        if c_ext.analyze!(html)
          a.contents_preview = c_ext.get_body_text[0,200]
          a.save
        end
      else
        Rails.logger.warn("[PreviewingJob]Can't get html:#{a.url}")
      end
    end
  end

  class ThumbnailingJob
    include ContentsExtractor
    THRESHOLD_IMAGE_SIZE = 100
    MAX_CHECK_IMAGE_NUMS = 20
    ADVERTISEMENT_LIST = [
      "amazon",
      "rakuten",
      "bannar",
      "Bannar",
      "ad.jp.doubleclick.net",
      "api.amebame.com",
      "stat.profile.ameba.jp",
      "accesstrade",
      "blank"
    ]
    EXCEPTION_PAGE_LIST = [
      "http://g-ec2.images-amazon.com/images/G/09/gno/beacon/BeaconSprite-JP-02._V393500380_.png",
      "http://livedoor.blogimg.jp/news23vip/imgs/a/d/adb3fd09.png"
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
    #広告画像を排除する
    #画像URLにADVERTISEMENT_LISTが含まれる場合は広告と判断する
    #登録しようとしているURLにADVERTISEMENT_LISTが含まれる場合は
    #何もしない
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

    def get_image_size(img_url)
      begin
        file = ImageSize.new(open(img_url, "rb").read)
      rescue => e
        Rails.logger.info("[get_image_size:ImageSize] " + 
                          "Can't get image size #{img_url} : #{e}")
        return 0
      end
      if(file.width && file.height && 
         file.width > THRESHOLD_IMAGE_SIZE && 
         file.height > THRESHOLD_IMAGE_SIZE)
        denominator = (file.width > file.height) ? 
          (file.width / file.height) : (file.height / file.width)
        return (file.width * file.height) / denominator
      else
        Rails.logger.info("[get_image_size:ImageSize] " + 
                          "Can't get image size #{img_url} : " +
                          "this image doesn't have the size infomation.")
        return 0
      end
    end

    def get_image_size_from_css(img)
      w = img["width"].to_f
      h = img["height"].to_f
      if(w && h &&
         w > THRESHOLD_IMAGE_SIZE &&
         h > THRESHOLD_IMAGE_SIZE)
        denominator = (w>h) ? w/h : h/w
        return 10 * (w*h)/denominator
      else
        Rails.logger.info("[get_image_size_from_css:ImageSize] " + 
                          "Can't get image size #{img["src"]} : " +
                          "this image doesn't have the size infomation.")
        return nil
      end
    end

    def get_image_url(a)
      img_url = nil
      c_ext = ExtractorFactory.instance.new_extractor(a.url)
      html = c_ext.openurl_wrapper(a.url)
      unless html
        Rails.logger.warn("[get_image_url]Can't get html:#{a.url}")
        return "no_image.png"
      end
      begin
        doc = Nokogiri::HTML.parse(html)
      rescue => e
        Rails.logger.info("get_image_url: #{e}")
        return "no_image.png"
      end
      max_size = THRESHOLD_IMAGE_SIZE * THRESHOLD_IMAGE_SIZE
      maz_size_img_url = 'no_image.png'
      #doc.xpath("//img").each_with_index do |img, idx|
      doc.css('img').each_with_index do |img, idx|
        img_url = img["src"]
        Rails.logger.debug("[#{idx}]img_url = #{img_url}")
        break if idx > MAX_CHECK_IMAGE_NUMS
        next if img_url == nil or img_url == ""
        next if isAdvertisement?(img_url)
        next if isExceptionImage?(img_url)
        unless img_url.start_with?("http")
          begin
            img_url = URI.join(a.url, img_url).to_s
          rescue => err_uri
            Rails.logger.debug("[#{idx}]img_url = #{img_url}")
            next
          end
        end
        img_size = get_image_size_from_css(img)
        unless img_size
          img_size = get_image_size(img_url)
        end
        Rails.logger.debug("[#{idx}] img_size: #{img_size}, #{img_url}")
        if img_size > max_size
          max_size = img_size
          maz_size_img_url = img_url
        end
      end
      return maz_size_img_url
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
