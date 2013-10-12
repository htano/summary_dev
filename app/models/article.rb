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

  #指定されたタグ情報ももつ記事を取得する
  def self.search_by_tag(tag)
    return nil if tag == nil || tag == BLANK
    articles = joins(:user_articles => :user_article_tags).where(["user_article_tags.tag LIKE ?", "%"+tag+"%"]).order("created_at desc")
    return articles
  end

  def get_marked_user
    return self.user_articles.count
  end

  def read?(user)
    unless user == nil then
      user_article = self.user_articles.find_by(:user_id => user.id)
      unless  user_article == nil then
        if user_article.read_flg == true then
          is_read = true
        else
          is_read = false
        end
      else
        is_read = false 
      end
    else
      is_read = false 
    end  
    return is_read
  end

  def get_good_score_sorted_summary_list(user)
    score_item = Struct.new(:summary,:good_summary_point)
    score_list = Array.new 
    is_good_completed = Array.new

    self.summaries.each_with_index do |summary,i|  

      good_summary_point = summary.good_summaries.count

      score_list[i] = score_item.new(summary, good_summary_point)
    end 


    #sort summary list
    #
    #
    #Under Construction
    score_list_sorted = score_list.sort{|i,j|
        j.good_summary_point<=>i.good_summary_point                 
    }
    #
    #

    summary_item = Struct.new(:summary, :user, :summary_point, :is_good_completed) 
    summary_list = Array.new
    #insert to each params  
    score_list_sorted.each_with_index do |score_item, i|         
      unless user == nil then
        unless score_item.summary.good_summaries.find_by(:user_id => user.id) == nil then 
          is_good_completed = true
        else
          is_good_completed = false 
        end
      else
        is_good_completed = false 
      end  
      summary_list[i] = summary_item.new(score_item.summary, score_item.summary.user,score_item.good_summary_point,is_good_completed)  
    end

    return summary_list
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
