describe FurAffinity::Page do
  let(:page){ FurAffinity::Page.new(fixture("notes")) }

  context "Page" do
    it "username" do
      expect(page.username).to eq("ew-test-account")
    end

    it "notification_summary" do
      expect(page.notification_summary).to eq("1S 1W 2C 5F 2N")
    end

    it "notification_counts" do
      expect(page.notification_counts).to eq([
        "1 Submission Notifications",
        "1 Watch Notifications",
        "2 Comment Notifications",
        "5 Favorite Notifications",
        "2 Unread Notes",
      ])
    end
  end

  context "Note Body" do
    let(:page){ FurAffinity::Page.new(fixture("note")) }
    let(:note_body) do
      <<~TEXT.strip
        Automatic linking: https://www.dropbox.com/s/7qnuc7t216vq4q9/feral-ref-by-tiggerpup.png?dl=0

        Bare link in bold: https://www.dropbox.com/s/7qnuc7t216vq4q9/feral-ref-by-tiggerpup.png?dl=0

        Explicit link in bold: https://www.dropbox.com/s/7qnuc7t216vq4q9/feral-ref-by-tiggerpup.png?dl=0

        Explicit link in bold: Link name (https://www.dropbox.com/s/7qnuc7t216vq4q9/feral-ref-by-tiggerpup.png?dl=0)

        Link name (https://www.dropbox.com/s/7qnuc7t216vq4q9/feral-ref-by-tiggerpup.png?dl=0)

        BoldItalic
        Bold Italic
        underline
        Bold Italic

        left
        center
        right


        Bold left
        Italic center
        underline right
      TEXT
    end

    it "contents" do
      expect(page.note_body).to eq(note_body)
    end
  end

  context "Notes" do
    let(:notes){ page.notes }
    let(:note){ notes.first }

    it "count" do
      expect(notes.count).to eq(3)
    end

    context "single note" do
      it "id" do
        expect(note.id).to eq(118495082)
      end

      it "url" do
        expect(note.url).to eq("https://www.furaffinity.net/msg/pms/1/118495082/#message")
      end

      it "subject" do
        expect(note.subject).to eq("Testing Truncated Links")
      end

      it "sender" do
        expect(note.sender).to eq("EpochWolf")
      end

      it "sender_url" do
        expect(note.sender_url).to eq("https://www.furaffinity.net/user/epochwolf/")
      end

      it "datetime" do
        expect(note.datetime).to eq("Nov 4, 2020 07:42AM")
      end

    end
  end
end




