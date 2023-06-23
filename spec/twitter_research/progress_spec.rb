# frozen_string_literal: true

describe TwitterResearch::Progress do
  subject(:progress) { described_class.new output: out_stub }

  let(:output) { [] }
  let(:out_stub) { ->(out) { output << out } }

  it "prints dots" do
    3.times { progress.tick }
    expect(output.join).to eq "..."
  end

  it "prints every 100 steps" do
    101.times { progress.tick }
    expect(output.join).to end_with ".. 100 ."
  end

  it "can be reset" do
    100.times { progress.tick }
    progress.reset
    200.times { progress.tick }
    expect(output.join).to end_with ".. 200 "
  end

  it "allows custom step size" do
    progress.step = 3
    9.times { progress.tick }
    expect(output.join).to eq ".. 3 .. 6 .. 9 "
  end

  it "adds total info" do
    progress.total = 250
    100.times { progress.tick }
    expect(output.join).to end_with "100/250 "
  end
end
