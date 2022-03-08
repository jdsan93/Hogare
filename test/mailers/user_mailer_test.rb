require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "orders" do
    mail = UserMailer.orders
    assert_equal "Orders", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
