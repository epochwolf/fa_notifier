# frozen_string_literal: true

class DataFile
  @default_config = nil
  class << self
    attr_accessor :default_config
  end

  def self.default
    new(default_config)
  end

  def initialize(filename)
    @filename = filename

    @data = if File.file?(@filename)
      Psych.load_file(@filename)
    else
      {}
    end
  end

  # Defining each method so it's easier to find the definition.
  #
  # 1. For small projects this isn't necessary but when you get to tens of
  # thousands of lines, it's nice to be able to search for
  # "def last_submission_id"
  #
  # 2. This also makes it easier for any tools that scan code to find method
  # definitions.
  #
  # 3. Meta-programming isn't necessary to make things faster to change.
  # Sublime's multi-cursor allows you to edit all of the methods at the same
  # time.
  #
  # 4. Code is infrequently writing, and frequently read. Saving time writing
  # code at the expense of future readability is a poor trade-off.

  def last_submission_id
    @data["last_submission_id"] || 0
  end

  def last_note_id
    @data["last_note_id"] || 0
  end

  def last_submission_id=(int)
    @data["last_submission_id"] = int.to_i
  end

  def last_note_id=(int)
    @data["last_note_id"] = int.to_i
  end

  def last_save
    @data["last_save"]
  end

  def data
    # Easy way to do a deep clone (At the cost of performance).
    Marshal.load(Marshal.dump(@data))
  end

  def save # => true | false
    @data["last_save"] = Time.now
    File.write(@filename, Psych.dump(@data))
  end
end
