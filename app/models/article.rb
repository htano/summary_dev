# encoding: utf-8

require "ransack"

class Article < ActiveRecord::Base
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy

  # This is a decay parameter for article's strength.
  # A 'point' means a people say he is reading the article.
  # And the points are decaying by time spending.
  # This parameter means that '1' point will decay to '0.01' point until some days after.
  ZERO_ZERO_ONE_DAYS = 7
  DECAY_DELTA = 0.01**(1.0/(24*ZERO_ZERO_ONE_DAYS))

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
  def self.getHotEntryArtileList
    # まず７日(ZERO_ZERO_ONE_DAYS)以内に「あとで読む登録」された記事のうち、
    # 最終登録時の「勢い(strength)」でソートした上位１００件くらいを取ってくる
    # 1. getCandidateHotentries
    @candidate_entries = where("last_added_at > ?", Time.now - ZERO_ZERO_ONE_DAYS.days).order('strength desc').limit(100)
    # 2. sort by current strength
    return @candidate_entries.sort{|a,b| (-1)*(a.getCurrentStrength <=> b.getCurrentStrength)}
  end

  # Instance Method
  def addStrength
    if self.last_added_at && self.strength
      @diff_hours = ((Time.now - self.last_added_at) / 1.hours).to_i
      self.strength = self.strength * (DECAY_DELTA**@diff_hours) + 1
    else
      self.strength = 1.0
    end
    self.last_added_at = Time.now
    return self.save
  end

  def getCurrentStrength
    @current_strength = 0
    if self.last_added_at && self.strength
      @diff_hours = ((Time.now - self.last_added_at) / 1.hours).to_i
      @current_strength = self.strength * (DECAY_DELTA**@diff_hours)
    end
    return @current_strength
  end

  def getTopRatedSummary
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

  #指定されたURLに対して登録数が多いタグ情報を取得するメソッド
  def self.get_top_rated_tag(url)
    first_index = 0
    last_index = 9
    top_rated_tags = joins(:user_articles => :user_article_tags).where("url" => url).group("tag").order("count_tag desc").count("tag").keys
    return top_rated_tags[first_index..last_index]
  end

  #ユーザーが最近登録したタグ情報を取得するメソッド
  def self.get_recent_tag(user_id)
    first_index = 0
    last_index = 9
    recent_tags = joins(:user_articles => :user_article_tags).where("user_articles.user_id" => user_id).group("tag").order("user_article_tags.created_at desc").count("tag").keys
    return recent_tags[first_index..last_index]
  end


  #指定されたタグ情報ももつ記事を取得する
  def self.search_by_tag(tag)
    articles = joins(:user_articles => :user_article_tags).where(["user_article_tags.tag LIKE ?", "%"+tag+"%"]).order("created_at desc")
    return articles
  end

  def self.get_popular_tag
    first_index = 0
    last_index = 14
    popular_tags = joins(:user_articles => :user_article_tags).group("tag").order("count_tag desc").count("tag").keys
    return popular_tags[first_index..last_index]    
  end
end
