# frozen_string_literal: true

describe TwitterResearch::Database::Tweet do
  subject(:tweet) { build :tweet }

  it 'allows to fetch a random tweet' do
    create_list :tweet, 3
    expect(described_class.random).not_to be_nil
  end
end

