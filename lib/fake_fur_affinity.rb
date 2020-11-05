require_relative "fur_affinity"

class FakeFurAffinity < FurAffinity

  @default_config=nil
  class << self
    attr_accessor :default_config
  end

  def self.default
    new(default_config, FurAffinity.default_config)
  end

  class Page < FurAffinity::Page
    def initialize(folder, *args)
      @folder = folder
      super(*args)
    end

    def submissions
      super.each do |sub|
        sub.instance_variable_set(:@image_data, nil)
      end
    end

    def notes
      super.each do |note|
        body = FurAffinity::Page.new(File.read(File.join(@folder, "note.html"))).note_body
        note.instance_variable_set(:@body, body)
      end
    end
  end

  def initialize(folder, *args)
    @folder = folder
    super(*args)
  end

  def submissions_page
    Page.new(@folder, File.read(File.join(@folder, "submissions.html")))
  end

  def other_notifications_page
    Page.new(@folder, File.read(File.join(@folder, "other.html")))
  end

  def notes_page
    Page.new(@folder, File.read(File.join(@folder, "notes.html")))
  end

end
