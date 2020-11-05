# frozen_string_literal: true
# https://webdesign.tutsplus.com/tutorials/creating-a-future-proof-responsive-email-without-media-queries--cms-23919

class Mailer

  @default_config = nil
  class << self
    attr_accessor :default_config
  end

  def self.default
    new(default_config)
  end

  def initialize(email_config)
    @smtp_config = email_config['smtp']
    @from = email_config["from"]
    @to = email_config["to"]
    @send_error_emails = email_config['send_error_emails']
  end

  def deliver_text(subject, text)
    deliver do |mail|
      mail.subject = subject
      mail.body = text
    end
  end

  def deliver_html(subject, html)
    deliver do |mail|
      mail.subject = subject
      mail.html_part do
        content_type 'text/html; charset=UTF-8'
        body html
      end
    end
  end

  private
  def deliver(&block)
    mail = Mail.new
    mail.from = @from
    mail.to = @to
    mail.delivery_method :smtp, @smtp_config
    block.call(mail)
    mail.deliver
  rescue => e
    raise unless @send_error_emails
    mail = Mail.new do
      from @from
      to @to
    end
    mail.subject = "#{e.class.name}: #{e.message}"
    mail.body    = "#{e.class.name}: #{e.message}\n#{e.backtrace.join("\n")}"
    mail.delivery_method :smtp, @smtp_config
    mail.deliver
  end
end
