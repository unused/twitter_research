# frozen_string_literal: true

module TwitterResearch
  # Text Predicitions using normalization.
  class TextPrediction
    attr_accessor :records
    attr_writer :totals # the overall count of word occurences

    def initialize
      @records = Hash.new 0
    end

    # combine all words, the number of times a words appears is split to the
    # typical occurrence of the word.
    def [](words)
      words.map do |word, count|
        next 0 unless @records.key? word

        probability_for count, word
      end.reject(&:zero?).inject(&:*)
    end

    def <<(words) = words.each { |key, val| @records[key] += val }

    def sum = @records.values.sum

    def to_h = @records.keys.map { |key| [key, self[key]] }.to_h

    def probability_for(count, word)
      Rational(Rational(count, @records[word]), @totals[word])
    end
  end
end
