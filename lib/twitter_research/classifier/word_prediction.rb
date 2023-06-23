# frozen_string_literal: true

module TwitterResearch
  # Word Predicitions using normalization.
  class WordPrediction
    attr_accessor :records, :totals

    def initialize
      @records = Hash.new 0
    end

    def [](key)
      return 0.00001 if totals[key]&.zero?

      Rational(@records[key], totals[key] || 1)
    end

    def <<(key) = @records[key] += 1

    def sum = @records.values.sum

    def to_h = @records.keys.map { |key| [key, self[key]] }.to_h
  end
end
