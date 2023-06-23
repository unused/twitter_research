# frozen_string_literal: true

# Provides a 70, 30 split.
class DataSplit
  attr_accessor :records

  def initialize(records)
    @records = records
  end

  def shuffle! = @records.shuffle!

  def with_training_set(&block)
    @users[split..].each(block)
  end

  def with_test_set(&block)
    @records[...split].each(block)
  end

  private

  def split = (@records.count * 0.7).to_i
end
