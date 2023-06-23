# frozen_string_literal: true

describe TwitterResearch::Follower do
  subject(:followers) { described_class.find id }
  let(:id) { "48285188" }


  describe "#find" do
    it "normalizes a username" do
      VCR.use_cassette("followers-find") do
        expect(followers.count).to eq 2
      end
    end
  end
end
