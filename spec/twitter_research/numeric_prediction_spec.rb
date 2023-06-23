# frozen_string_literal: true

describe TwitterResearch::NumericPrediction do
  subject(:prediction) { described_class.new }

  it "handles single value" do
    [13].each { |val| prediction << val }
    expect(prediction[13]).to be 1.0
  end

  it "handles single value mismatch" do
    [13].each { |val| prediction << val }
    expect(prediction[12]).to be_nil
  end

  it "handles multi-single value" do
    [13, 13, 13, 13].each { |val| prediction << val }
    expect(prediction[13]).to be 1.0
  end

  it "handles multi-single value mismatch" do
    [13, 13, 13, 13].each { |val| prediction << val }
    expect(prediction[12]).to be_nil
  end

  it "matching probability" do
    [11, 12, 13, 14, 15].each { |val| prediction << val }
    expect(prediction[13]).to be_within(0.1).of 0.25
  end

  it "supports float values" do
    [1.5, 3.0, 4.5].each { |val| prediction << val }
    expect(prediction[2.9]).to be_within(0.05).of 0.25
  end
end
