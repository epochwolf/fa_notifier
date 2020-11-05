# frozen_string_literal: true
require_relative 'fa_notifier'
require "fileutils"

task :default => [:read]

desc "Send summary email"
task :send do
  email = Email::Summary.new(FurAffinity.default)
  Mailer.default.deliver_html(email.subject, email.html)
end


desc "Send email for new submissions and notes since last time this email was sent."
task :send_new do
  data = DataFile.default
  site = FurAffinity.default
  email = Email::FilteredSummary.new(site,
            note_id: data.last_note_id,
            submission_id: data.last_submission_id,
          )
  next if email.empty?

  Mailer.default.deliver_html(email.subject, email.html)

  data.last_note_id = email.max_note_id if email.max_note_id
  data.last_submission_id = email.max_submission_id if email.max_submission_id
  data.save
end


desc "Send a test email to see if email configuration is working."
task :send_test do
  page = FurAffinity::Page.new(File.read(FaNotifier.root.join("tmp", "submissions.html")))
  Mailer.default.deliver_text(page.notification_summary, "Test Email")
end

desc "Resets the data.yml so send_new ignores anything before this point."
task :reset_data do
  data = DataFile.default
  site = FurAffinity.default
  email = Email::FilteredSummary.new(site, note_id: 0, submission_id: 0)
  data.last_note_id = email.max_note_id || 0
  data.last_submission_id = email.max_submission_id || 0
  data.save
end

# == Everything after this point is used for development and testing ==

desc "Download fresh copies of all pages to tmp/"
task :download => [:backup_tmp] do
  # By default, FakeFurAffinity uses these files.
  write_page "submissions",  FurAffinity::SUBMISSIONS_URL
  write_page "other",        FurAffinity::OTHER_URL
  page = write_page "notes", FurAffinity::NOTES_URL

  note_url = FurAffinity::Page.new(page).notes[0].url
  write_page "note", note_url
end


desc "Back up files in tmp folder to a timestamped folder"
task :backup_tmp do
  backup_pages(*%w(submissions other notes note))
end


desc "Writes the body of the summary email to tmp/ using downloaded files."
task :test_send do
  site = FakeFurAffinity.default
  email = Email::Summary.new(site)
  File.open("tmp/summary_email.html", 'w'){|f| f.write(email.html) }
end


desc "Writes the body of the new email to tmp/ using downloaded files."
task :test_send_new do
  data = DataFile.default
  site = FakeFurAffinity.default
  email = Email::FilteredSummary.new(site,
            note_id: data.last_note_id,
            submission_id: data.last_submission_id,
          )
  File.open("tmp/new_email.html", 'w'){|f| f.write(email.html) }
end


desc "Display all information about downloaded files."
task :read do
  site = FakeFurAffinity.default
  note = site.notes.first

  puts site.username
  puts site.notification_summary
  puts site.notification_counts
  puts ""
  puts "SUBMISSIONS"
  site.submissions.each do |sub|
    puts ""
    puts sub.id
    puts sub.title
    puts sub.date
    puts sub.user
    puts sub.view_url
    puts sub.image_url
  end
  puts ""
  puts "NOTIFICATIONS"
  site.other_notifications.each do |section, notices|
    puts ""
    puts section
    notices.each do |notice|
      puts notice.id
      puts notice.line
    end
  end
  puts ""
  puts "NOTES"
  site.notes.each do |note|
    puts ""
    puts note.id
    puts note.subject.inspect
    puts note.sender.inspect
    puts note.datetime.inspect
    puts note.url
  end
  puts ""
  puts "FIRST NOTE BODY"
  puts note.body
end


def backup_pages(*pages)
  new_dir = Time.now.strftime("%Y%m%dT%H%M%S")
  tmp_path = FaNotifier.root.join('tmp', new_dir)
  FileUtils.mkdir(tmp_path)

  FileUtils.cp(pages.map{|p| FaNotifier.root.join('tmp', "#{p}.html") }, tmp_path)
end


def write_page(name, url)
  response = HTTParty.get(url, cookies: SETTINGS["cookies"])

  if response.code == 200
    File.open(FaNotifier.root.join("tmp", "#{name}.html"), 'w'){|f| f.write(response.body) }
    response.body
  else
    puts response.body, response.code, response.message, response.headers.inspect
  end
end
