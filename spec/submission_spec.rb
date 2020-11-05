describe FurAffinity::Page do
  let(:page){ FurAffinity::Page.new(fixture("submissions")) }

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

  context "Submissions" do
    let(:submissions){ page.submissions }
    let(:submission){ page.submissions.first }

    context "single submission" do

      it "id" do
        expect(submission.id).to eq(39033507)
      end

      it "width" do
        expect(submission.width).to eq(158)
      end

      it "height" do
        expect(submission.height).to eq(200)
      end

      it "view_url" do
        expect(submission.view_url).to eq("https://www.furaffinity.net/view/39033507/")
      end

      it "image_url" do
        expect(submission.image_url).to eq("http://t.facdn.net/39033507@200-1604521905.jpg")
      end

      it "title" do
        expect(submission.title).to eq("Fantasy kitty")
      end

      it "user" do
        expect(submission.user).to eq("hibbary")
      end

      it "user_url" do
        expect(submission.user_url).to eq("https://www.furaffinity.net/user/hibbary")
      end

    end

    context "counts" do
      let(:expected) do
        [
          39033507,
        ]
      end

      it "submissions" do
        expect(submissions.map(&:id)).to eq(expected)
      end
    end
  end
end




