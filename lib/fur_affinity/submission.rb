# frozen_string_literal: true

class FurAffinity
  class Submission
    attr_reader :node, :date

    def initialize(node, date)
      @node = node # #messagecenter-submissions > section figure
      @date = date
    end

    def id
      node["id"]&.scan(/\d+/).first.to_i
    end

    def width
      image_node["data-width"].to_i
    end

    def height
      image_node["data-height"].to_i
    end

    def view_url
      if url = image_node&.parent["href"]
        "#{HOST}#{url}"
      end
    end

    def image_url
      image_node["src"]&.gsub(%r"^//", "http://")
    end

    # This is a convience method for use in email generation. It swallows
    # errors because images are not critical for the email to send.
    def image_data
      return @image_data if defined? @image_data
      @image_data = HTTParty.get(image_url).body rescue nil
    end

    def embed_image_data
      if image_data
        "data:image/jpg;base64,#{Base64.encode64(image_data)}"
      else
        # Single red pixel.
        "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg=="
      end
    end

    def title
      node.css("figcaption a[href^=\\/view]").first.content
    end

    def user
      node.css("figcaption a[href^=\\/user]").first.content
    end

    def user_url
      "#{HOST}/user/#{user}"
    end

    private
    def image_node
      node.css("a img").first
    end
  end
end
