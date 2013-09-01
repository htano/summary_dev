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
end
