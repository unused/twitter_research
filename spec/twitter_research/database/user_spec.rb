# frozen_string_literal: true

describe TwitterResearch::Database::User do
  subject(:user) { build(:user) }

  let(:urls) { [{ "expanded_url" => Faker::Internet.url }] }

  it "has a username" do
    expect(user.username).not_to be_empty
  end

  it "extracts websites from entities" do
    entities = { "url" => { "urls" => urls } }
    user.write_attribute(:entities, entities)
    expect(user.websites.count).to eq 1
  end

  it "extracts a followers ration" do
    ratio = user.followers_count.to_f / user.following_count
    expect(user.followers_ratio).to eq ratio
  end
end
