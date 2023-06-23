# frozen_string_literal: true

describe TwitterResearch::Request do
  subject(:request) { described_class.new path }

  let(:path) { "users/48285188" }

  before { described_class.api_token = "AAA..." }

  vcr = { cassette_name: "user-fetch" }
  it "requests twitter api", vcr: do
    expect(request.call).to be_successfull
  end

  it "provides response status code", vcr: do
    expect(request.call.response.code).to eq 200
  end

  it "provides raw response body", vcr: do
    expect(request.call.body).to start_with '{"data":{'
  end

  it "provides request content", vcr: do
    expect(request.call.data).to have_key "username"
  end

  it "provides a shorthand for GET requests", vcr: do
    expect(described_class.get(path)).to be_successfull
  end
end
