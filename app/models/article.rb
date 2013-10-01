# encoding: utf-8

#require "ransack"

class Article < ActiveRecord::Base
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy

  # This is a decay parameter for article's strength.
  # A 'point' means a people say he is reading the article.
  # And the points are decaying by time spending.
  # This parameter means that '1' point will decay to '0.01' point until some days after.
  ZERO_ZERO_ONE_DAYS = 7
  DECAY_DELTA = 0.01**(1.0/(24*ZERO_ZERO_ONE_DAYS))
  BLANK = ""

  #指定されたタグ情報を持つ記事を取得する
  def self.search_by_tag(tag)
    return nil if tag == nil || tag == BLANK
    articles = joins(:user_articles => :user_article_tags).where(["user_article_tags.tag LIKE ?", "%"+tag+"%"]).group("id")
    return articles
  end

  #指定されたタイトルを持つ記事を取得する
  def self.search_by_title(title)
    return nil if title == nil || title == BLANK
    articles = joins(:user_articles => :user_article_tags).where(["title LIKE ?", "%"+title+"%"]).group("id")
    return articles
  end

  #指定された本文を持つ記事を取得する
  def self.search_by_content(content)
    return nil if content == nil || content == BLANK
    articles = joins(:user_articles => :user_article_tags).where(["contents_preview LIKE ?", "%"+content+"%"]).group("id")
    return articles
  end

  def getMarkedUser
    return self.user_articles.count
  end

  def isRead(user)
    unless user == nil then
      userArticleForIsRead = self.user_articles.find_by(:user_id => user.id)
      unless  userArticleForIsRead == nil then
        
        if userArticleForIsRead.read_flg == true then
        
                isRead = true

        else
            
        isRead = false

        end

      else
        isRead = false 
      end
    else
      isRead = false 
    end  
    return isRead
  end

  def getSortedSummaryList(user)
    #create array for calcration 
    scoreItem = Struct.new(:summary,:goodSummaryPoint)
    scoreList = Array.new 
    isGoodCompleted = Array.new

    self.summaries.each_with_index do |summary,i|  

      #calcurate goodSummaryPoint 
      goodSummaryPoint = summary.good_summaries.count

      #scoreItem
      scoreList[i] = scoreItem.new(summary, goodSummaryPoint)
    end 


    #sort summary list
    #
    #
    #Under Construction
    scoreList_sorted = scoreList.sort{|i,j|
        j.goodSummaryPoint<=>i.goodSummaryPoint                 
    }
    #
    #

    summaryItem = Struct.new(:summary, :user, :summaryPoint, :isGoodCompleted) 
    summaryList = Array.new
    #insert to each params  
    scoreList_sorted.each_with_index do |scoreItem, i|         
      unless user == nil then
        unless scoreItem.summary.good_summaries.find_by(:user_id => user.id) == nil then 
          isGoodCompleted = true
        else
          isGoodCompleted = false 
        end
      else
        isGoodCompleted = false 
      end  
      summaryList[i] = summaryItem.new(scoreItem.summary, scoreItem.summary.user,scoreItem.goodSummaryPoint,isGoodCompleted)  
    end

    return summaryList
  end

  # Class Method
  def self.get_hotentry_articles
    # 1. getCandidateHotentries
    @candidate_entries = where("last_added_at > ?", Time.now - ZERO_ZERO_ONE_DAYS.days).order('strength desc, last_added_at desc').limit(100)
    # 2. sort by current strength
    return @candidate_entries.sort{|a,b| (-1)*(a.get_current_strength <=> b.get_current_strength)}.first(20)
  end

  # Instance Method
  def add_strength
    if self.last_added_at && self.strength
      @diff_hours = ((Time.now - self.last_added_at) / 1.hours).to_i
      self.strength = self.strength * (DECAY_DELTA**@diff_hours) + 1
    else
      self.strength = 1.0
    end
    self.last_added_at = Time.now
    return self.save
  end

  def remove_strength(uid)
    @user_article = self.user_articles.find_by_user_id(uid)
    if @user_article && self.strength && self.last_added_at
      @user_added_at = @user_article.created_at
      @hours_from_last_add = ((Time.now - self.last_added_at) / 1.hours).to_i
      @hours_from_user_add = ((Time.now - @user_added_at) / 1.hours).to_i
      self.strength = self.strength * (DECAY_DELTA**@hours_from_last_add) - 1.0 * (DECAY_DELTA**@hours_from_user_add)
      self.last_added_at = Time.now
      return self.save
    else
      return false
    end
  end

  def get_current_strength
    @current_strength = 0
    if self.last_added_at && self.strength
      @diff_hours = ((Time.now - self.last_added_at) / 1.hours).to_i
      @current_strength = self.strength * (DECAY_DELTA**@diff_hours)
    end
    return @current_strength
  end

  def get_top_rated_summary
    @top_rated_summary = nil
    @top_rate = -1
    self.summaries.order('created_at desc').each do |summary|
      if @top_rate < summary.good_summaries.count
        @top_rate = summary.good_summaries.count
        @top_rated_summary = summary
      end
    end
    return @top_rated_summary
  end

  #記事に設定されたタグ情報を登録順に取得するメソッド
  def get_top_rated_tag
    first_index = 0
    last_index = 9
    return Article.joins(:user_articles => :user_article_tags).where("url" => self.url).group("tag").order("count_tag desc").count("tag").keys[first_index..last_index]
  end
end
