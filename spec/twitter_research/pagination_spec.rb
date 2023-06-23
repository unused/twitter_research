# frozen_string_literal: true

describe TwitterResearch::Pagination do
  subject(:pagination) { Class.new.extend described_class }

  let(:params) { [] }

  stub = Struct.new(:data, :meta)

  it "paginates until no next token is given" do
    responses = [stub.new([1, 2], { "next_token" => "six" }),
                 stub.new([3, 4], { "next_token" => "seven" }),
                 stub.new([5, 6], {})]

    expect(pagination.with_pagination { responses.shift }).to \
      eq [1, 2, 3, 4, 5, 6]
  end

  it "adds pagination token to params" do
    responses = [stub.new([1], { "next_token" => "seven" }), stub.new([2], {})]

    pagination.with_pagination do |current|
      params.push(current["pagination_token"]) and responses.shift
    end
    expect(params).to eq [nil, "seven"]
  end
end
