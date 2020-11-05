require 'rubygems'
require 'bundler/setup'
require_relative "lib/data_file"
require_relative "lib/fur_affinity"
require_relative "lib/mailer"
require_relative "lib/email/summary"
require_relative "lib/email/filtered_summary"
require_relative "lib/fake_fur_affinity"


ROOT_PATH = Pathname.new(File.absolute_path(__dir__)).freeze

class FaNotifier
  def self.root
    ROOT_PATH
  end
end

Bundler.require

SETTINGS = Psych.load_file(FaNotifier.root.join("settings.yml"))
DataFile.default_config        = FaNotifier.root.join("data.yml")
FakeFurAffinity.default_config = FaNotifier.root.join("tmp")
FurAffinity.default_config     = SETTINGS.fetch("cookies")
Mailer.default_config          = SETTINGS.fetch("email")

