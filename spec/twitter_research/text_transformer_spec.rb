# frozen_string_literal: true

describe TwitterResearch::TextTransformer do
  subject(:transformer) { described_class.new }

  it "handles non alphabetic characters" do
    transformer.text = "Another... VERY strange!!! example"
    expect(transformer.words).to eq %w[another very strange example]
  end

  it "removes stopwords" do
    transformer.text = "A silly example by me"
    expect(transformer.filtered).to eq %w[silly example]
  end

  it "stem words" do
    skip "we stopped stemming for now"
    transformer.text = "Things"
    expect(transformer.tally.keys).to eq %w[things]
  end

  it "transforms text" do
    transformer.text = "This is a good example, or is it a bad example?"
    result = { "good" => 1, "example" => 2, "bad" => 1 }
    expect(transformer.tally).to eq result
  end
end
