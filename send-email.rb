require 'sendgrid-ruby'
include SendGrid

from = SendGrid::Email.new(email: 'noreply@hoga-re.com')
to = SendGrid::Email.new(email: 'mamalvarez11@gmail.com')
subject = 'Sending with Twilio Sendgrid is fun...'
content = SendGrid::Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby!')
mail = SendGrid::Mail.new(from, subject, to, content)

sg = SendGrid::API.new(api_key: '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')
response = sg.client.mail._('send').post(request_body: mail.to_json)

puts response.status_code
puts response.body
puts response.headers
