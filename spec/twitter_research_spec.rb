# frozen_string_literal: true

describe TwitterResearch do
  subject(:research) { Class.new { extend TwitterResearch } }

  it "has version number" do
    expect(described_class::VERSION).to eq "0.1.0"
  end
end
