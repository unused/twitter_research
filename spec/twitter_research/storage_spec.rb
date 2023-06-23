# frozen_string_literal: true

require "tmpdir"

describe TwitterResearch::Storage do
  subject(:store) { described_class.new basename }

  let(:basename) { Faker::Internet.username }
  let(:content) { Faker::Types.complex_rb_hash }

  around do |example|
    Dir.mktmpdir do |dir|
      described_class.directory = dir
      example.run
    end
  end

  it "responds write with success" do
    expect(store.write(content.to_json)).to be_truthy
  end

  it "writes file" do
    store.write content
    expect(File.read(store.filepath)).to eq content.to_json
  end

  it "recovers data content" do
    store.write content
    expect(store.content).to eq content
  end

  it "prevents file overwrite" do
    store.write content
    expect(store.write(content)).to be_falsy
  end
end
