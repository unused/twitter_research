# frozen_string_literal: true

describe TwitterResearch::DSL do
  subject(:dsl) { Class.new { extend TwitterResearch::DSL }}

  describe '#stored' do
  end

  describe '#twitter' do
    it "provides a endpoint lookup" do
      expect(dsl.twitter(:user)).to eq TwitterResearch::User
    end
  end

  describe '#logger' do
    let(:logfile) { "log/test.log" }

    it "is available" do
      msg = Faker::Movies::HarryPotter.quote
      dsl.instance_variable_set :@logger, Logger.new(logfile)
      dsl.logger.warn(msg)
      expect(File.read(logfile)).to end_with "#{msg}\n"
    end
  end
end
