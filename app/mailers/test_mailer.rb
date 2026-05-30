class TestMailer < ApplicationMailer
  def test_email
    @body = params[:body]

    mail(
      to: params[:to],
      subject: params[:subject]
    )
  end
end
