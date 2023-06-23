# frozen_string_literal: true

describe TwitterResearch::Report do
  subject(:report) { described_class.new matches }

  # example from https://www.v7labs.com/blog/confusion-matrix-guide
  #
  # predicts => { actual: count-of-pr
  let(:matches) do
    {
      1 => { 1 => 52, 2 => 3, 3 => 7, 4 => 2 },
      2 => { 1 => 2, 2 => 28, 3 => 2, 4 => 0 },
      3 => { 1 => 5, 2 => 2, 3 => 25, 4 => 12 },
      4 => { 1 => 1, 2 => 1, 3 => 9, 4 => 40 }
    }
  end

  it "provides precision of base class" do
    skip
    expect(report.f_measure(1)).to be_within(0.0001).of 0.8387
  end
end
