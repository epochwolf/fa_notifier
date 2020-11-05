# frozen_string_literal: true

class FurAffinity
  class OtherNotifcation
    attr_reader :node, :section

    def initialize(node, section)
      @node = node # ul.message-stream > li
      @section = section
    end

    def id
      node.css("input[type=checkbox]").first["value"].to_i
    end

    # This gets rather gnarly. FurAffinity has a lot of different types of
    # notifications on this page. There is a general pattern to them. Inside
    # the li tag, you typically have text, a, and span nodes making up the
    # line that's displayed for that notification type.
    #
    # Journal and Watches are formatted differently but still follow the same
    # general pattern
    def line
      line_node = case section
      when /journal/i then node.css(".cell")
      when /watches/i then node.css(".info")
      else node
      end

      chunks = line_node.children.map do |node2|
        next [:text, node2.content.strip] if node2.text?

        case node2.name
        when "text"
        when "span" then [:text, node2.content]
        when "a"    then [:a, node2.content, "#{HOST}#{node2["href"]}"]
        # Submission Comments wrap the title in <strong/>
        when "strong" then (a = node2.css("a").first) && [:a, a.content, "#{HOST}#{a["href"]}"]
        # Watches wrap the date in <small/>
        when "small" then (a = node2.css("span").first) && [:text, node2.content]
        end
      end.compact.reject{|v| v[1].empty? }

      return nil if chunks.empty?

      html = Nokogiri::HTML::Builder.new do |doc|
        doc.root do
          chunks.each do |chunk|
            case chunk[0]
            when :text
              doc.text(" #{chunk[1]} ")
            when :a
              doc.a(href: chunk[2]){ doc.text(chunk[1]) }
            end
          end
        end
      end.to_html

      html.gsub(/\A<!.+<root>(.*)<\/root\>\s*\z/m, "\\1").gsub(/\s\s+/, " ").strip
    end
  end
end
