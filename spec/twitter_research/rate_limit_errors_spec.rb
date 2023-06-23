# frozen_string_literal: true

describe TwitterResearch::RateLimitError do
  subject(:err) { described_class.new request }

  let(:request) { Request.new response }
  let(:response) { Response.new({ "x-rate-limit-reset" => reset }) }
  let(:reset) { Time.now.to_i + (5 * 60) }

  before do
    stub_const "Request", Struct.new(:response)
    stub_const "Response", Struct.new(:headers)
  end

  it "reads timeout from header" do
    Time.freeze do
      timestamp_in_5_minutes = (Time.new + 300).to_i
      expect(err.reset_at).to eq timestamp_in_5_minutes
    end
  end
end
