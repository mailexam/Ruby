class MailController < ApplicationController
  def test
    payload = JSON.parse(request.body.read.presence || "{}")

    TestMailer.with(
      to: payload["to"].presence || "user@example.test",
      subject: payload["subject"].presence || "Ruby on Rails + Mailexam",
      body: payload["body"].presence || payload["text"].presence || "Mailexam test from Ruby on Rails"
    ).test_email.deliver_now

    render json: { status: "ok" }
  end
end
