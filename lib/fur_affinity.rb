# frozen_string_literal: true

require "base64"
require_relative "fur_affinity/page"
require_relative "fur_affinity/submission"
require_relative "fur_affinity/other_notification"
require_relative "fur_affinity/note"

class FurAffinity
  class Error < StandardError; end

  @default_config=nil
  class << self
    attr_accessor :default_config
  end

  HOST = "https://www.furaffinity.net"
  NOTES_URL = URI("#{HOST}/msg/pms/")
  OTHER_URL = URI("#{HOST}/msg/others/")
  SUBMISSIONS_URL = URI("#{HOST}/msg/submissions/")
  attr_reader :cookies

  def self.default
    new(SETTINGS["cookies"])
  end

  def initialize(cookies)
    @cookies = cookies
  end

  def username
    first_page.username
  end

  def notification_summary
    first_page.notification_summary
  end

  def notification_counts
    first_page.notification_counts
  end

  def notes
    @notes ||= notes_page.notes
  end

  def notes_page
    @notes_page ||= page(NOTES_URL)
  end

  def other_notifications
    @other_notifications ||= other_notifications_page.other_notifications
  end

  def other_notifications_page
    @other_notifications_page ||= page(OTHER_URL)
  end

  def submissions
    @submissions ||= submissions_page.submissions
  end

  def submissions_page
    @submissions_page ||= page(SUBMISSIONS_URL)
  end

  def first_page
    @submissions_page ||
    @other_notifications ||
    @notes_page ||
    submissions_page
  end

  # Raises:
  # - Nokogiri::XML::SyntaxError
  # - Error
  def page(url)
    response = HTTParty.get url, cookies: cookies
    body = if response.code
      response.body
    else
      raise Error, "#{response.code}: #{response.message}"
    end
    page = Page.new(body) # throws Nokogiri::XML::SyntaxError
    unless page.username
      raise Error, "Not logged in."
    end
    page
  end

end
