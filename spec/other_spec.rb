describe FurAffinity::Page do
  let(:page){ FurAffinity::Page.new(fixture("other")) }

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

  context "Other" do
    let(:notifications){ page.other_notifications }
    let(:watch){  notifications["Watches"].first }
    let(:comment){  notifications["Submission Comments"].first }
    let(:shout){    notifications["Shouts"].first }
    let(:favorite){ notifications["Favorites"].first }


    let(:expected_hash) do
      {
        "Watches"             => [124340506],
        "Submission Comments" => [151189799],
        "Shouts"              => [50196290],
        "Favorites"           => [1003354570, 1003188762, 1003082208, 1003067306, 1003066463],
      }
    end

    it "sections" do
      expect(notifications.keys).to eq(expected_hash.keys)
    end

    it "notifications" do
      expect(notifications.values.map{|arr| arr.map(&:id)}).to eq(expected_hash.values)
    end

    it "watch" do
      # TODO: Fix Watch notification to include links
      # line = "<a href=\"https://www.furaffinity.net/user/epochwolf/\">EpochWolf</a> Nov 3rd, 2020 03:06 PM"
      line = "EpochWolf Nov 3rd, 2020 03:06 PM"
      expect(watch.line).to eq(line)
    end

    it "comment" do
      line = "<a href=\"https://www.furaffinity.net/user/epochwolf/\">EpochWolf</a> replied to <a href=\"https://www.furaffinity.net/view/39016682/#cid:151189799\">Dragon Rider</a> on Nov 3, 2020 03:09 PM"
      expect(comment.line).to eq(line)
    end

    it "shout" do
      line = "<a href=\"https://www.furaffinity.net/user/epochwolf/\">EpochWolf</a> left a shout on Nov 3, 2020 03:06 PM"
      expect(shout.line).to eq(line)
    end

    it "favorite" do
      line = "<a href=\"https://www.furaffinity.net/user/clostridium/\">Clostridium</a> favorited <a href=\"https://www.furaffinity.net/view/39016682/\">\"Dragon Rider\"</a> Nov 4th, 2020 03:45 AM"
      expect(favorite.line).to eq(line)
    end

  end
end
