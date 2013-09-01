require 'test_helper'

class MessageTest < ActionMailer::TestCase
  test "change_mail_addr" do
    mail = Message.change_mail_addr
    assert_equal "Change mail addr", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
