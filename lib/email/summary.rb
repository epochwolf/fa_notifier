# frozen_string_literal: true
# https://webdesign.tutsplus.com/tutorials/creating-a-future-proof-responsive-email-without-media-queries--cms-23919

module Email
  class Summary
    attr_reader :fa

    TEMPLATE = File.join(__dir__, '../../templates/summary_email.html.erb')

    def initialize(fur_affinity)
      @fa = fur_affinity
    end

    def username
      fa.username
    end

    def notification_summary
      fa.notification_summary
    end

    def notification_counts
      fa.notification_counts
    end

    def notes
      fa.notes
    end

    def other_notifications
      fa.other_notifications
    end

    def submissions
      fa.submissions
    end

    def subject
      "#{fa.notification_summary} for #{fa.username}"
    end

    def render
      ERB.new(File.read(TEMPLATE)).result binding
    end
    alias html render
  end
end
