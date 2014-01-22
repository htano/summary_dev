class Message < ActionMailer::Base
  default from: "summary.dev@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message.change_mail_addr.subject
  #
  def change_mail_addr(user_name, mail_to, token_url)
    @user_name = user_name
    @mail_addr = mail_to
    @token_url = token_url

    mail(
      to: mail_to,
      subject: "[SummaryDev] Checking your email address changed.",
    )
  end

  def inform_user_number
    @user_num = User.all.size
    @article_num = Article.all.size
    @user_article_num = ""
    UserArticle.group(:user_id).count.sort_by{|k,v| -v}.first(10).each do |uid, num|
      @user_article_num += User.find(uid).name + ":\t#{num}\n"
    end
    @user_summary_num = ""
    Summary.group(:user_id).count.sort_by{|k,v| -v}.first(10).each do |uid, num|
      @user_summary_num += User.find(uid).name + ":\t#{num}\n"
    end
    d = Date.today
    mail(
      to: "toru1055h@gmail.com,shingo0809@gmail.com,tanohiro@gmail.com,xemurux@gmail.com,ahayashi10@gmail.com",
      #to: "toru1055h@gmail.com",
      subject: "[SummaQ] Statistical Report(#{d})"
    )
  end
end
