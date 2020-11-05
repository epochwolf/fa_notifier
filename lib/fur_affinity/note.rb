# frozen_string_literal: true

class FurAffinity
  class Note
    attr_reader :node

    def initialize(node)
      @node = node # #notes-list .note-list-container
    end

    def id
      url.scan(/\d+/).last.to_i
    end

    def  url
      if url = node.css('.note-list-subject-container a').first["href"]
        "#{HOST}#{url}"
      end
    end

    def subject
      node.css('.note-list-subject').xpath('text()').map do |text|
        text.content.strip
      end.reject(&:empty?).first
    end

    def body
      @body ||= begin
        response = HTTParty.get url, cookies: SETTINGS["cookies"]
        page = FurAffinity::Page.new(response.body)
        page.note_body.strip
      end
    end

    def sender
      node.css('.note-list-sender a').first.content
    end

    def sender_url
      url = node.css('.note-list-sender a').first["href"]
      "#{HOST}#{url}"
    end

    def datetime
      link = node.css('.note-list-senddate').first
      link.content.strip
    end
  end
end
