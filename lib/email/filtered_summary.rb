# frozen_string_literal: true
# https://webdesign.tutsplus.com/tutorials/creating-a-future-proof-responsive-email-without-media-queries--cms-23919

module Email
  class FilteredSummary
    attr_reader :fa, :min_note_id, :min_submission_id

    TEMPLATE = File.join(__dir__, '../../templates/new_email.html.erb')

    def initialize(fur_affinity, note_id:, submission_id:)
      @fa = fur_affinity
      @min_note_id  = note_id
      @min_submission_id = submission_id
    end

    def max_note_id
      return if notes.empty?
      notes.map(&:id).max
    end

    def max_submission_id
      return if submissions.empty?
      submissions.map(&:id).max
    end

    def username
      fa.username
    end

    def notification_summary
      "#{submissions.count}S #{notes.count}N"
    end

    def notification_counts
      [
        "#{submissions.count} Submission Notifications",
        "#{notes.count} Unread Notes",
      ]
    end

    def notes
      @notes ||= fa.notes.select{|n| n.id > min_note_id}
    end

    def other_notifications
      {}
    end

    def submissions
      @submissions ||= fa.submissions.select{|s| s.id > min_submission_id}
    end

    def empty?
      submissions.empty? && notes.empty?
    end

    def subject
      "New #{notification_summary} for #{username}"
    end

    def render
      ERB.new(File.read(TEMPLATE)).result binding
    end
    alias html render

    private
    def filter(value, array)

    end
  end
end
