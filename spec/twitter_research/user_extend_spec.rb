# frozen_string_literal: true

describe TwitterResearch::UserExtend do
  subject(:extended) { described_class.new user }

  let(:user) { create(:user) }
  let(:role) { "some-user" }

  describe "#normalize" do
    it "normalizes a username" do
      user = build(:user, username: "SeVen")
      described_class.new(user).normalize_username
      expect(user._username).to eq "seven"
    end
  end

  describe "#store_followers_ratio" do
    it "stores followers ratio" do
      user = build(:user)
      described_class.new(user).store_followers_ratio
      expect(user._followers_ratio).not_to be_nil
    end
  end

  describe "#classify" do
    it "classifies a user" do
      skip "using static classifier for now"

      create_list(:user, 3, _role: role, _labeled: %w[role])
      user = build(:user)
      described_class.new(user).classify
      expect(user._role).to eq role
    end
  end
end
