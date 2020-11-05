# frozen_string_literal: true

class FurAffinity
  class Page
    attr_reader :doc

    def initialize(html)
      @doc = Nokogiri::HTML(html)
    end

    def username
      doc.css('body #my-username.hideonmobile').first&.content&.gsub(  /\W+$/, "")
    end

    def notification_summary
      doc.css('nav#ddmenu li.message-bar-desktop a').map do |a|
        a.content.strip
      end.join " "
    end

    def notification_counts
      links = doc.css('nav#ddmenu li.message-bar-desktop a')
      links.map{|l| l["title"] }
    end

    def submissions
      elements = doc.css([
        "#messagecenter-submissions > h4.date-divider",
        "#messagecenter-submissions > section"
      ].join(", "))

      subs = []
      date = ""
      elements.each do |node|
        if node.name == "h4"
          date = Date.parse(node.content)
        elsif node.name == "section"
          subs << node.css("figure").map do |figure|
            Submission.new(figure, date)
          end
        end
      end
      subs.flatten
    end

    def other_notifications
      notices = {}
      section = ""
      doc.css("#messagecenter-other .section_container").each do |node|
        section = node.css('.section-header h2').first&.content
        notices[section] = node.css('ul.message-stream > li').map do |node2|
          OtherNotifcation.new(node2, section)
        end
      end
      notices
    end

    def notes
      elements = doc.css("#notes-list .note-list-container")
      elements.map do |e|
        Note.new(e)
      end
    end

    def note_body
      @note_body ||= begin
        node = doc.css("#message .user-submitted-links").first
        expand_a_tags!(node)
        node.content.strip.gsub(/\r\n/,"\n")
      end
    end

    protected
    # Inplace replacement of links so they work in email.
    def expand_a_tags!(node)
      if node.name == "a"
        return unless url = node["href"]
        link_name = node.content.strip
        return if url == link_name
        front, back = link_name.split('.....', 2)
        if back && url.start_with?(front) && url.end_with?(back)
          node.content = url
        else
          node.content = "#{node.content} (#{url})"
        end
      elsif !node.children.empty?
        node.children.each{|n| expand_a_tags!(n) }
      end
    end

  end
end
