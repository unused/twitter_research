# frozen_string_literal: true

require "enumerable/statistics"

module TwitterResearch
  # Training data is hash of hashes that hold the number of times something did
  # occure.
  class Bayes
    THRESHOLD = 0.5

    def initialize
      @total = 0
      @labels = Hash.new(0)

      @data = {}
      @cache = {}
    end

    def reset_cache = @cache = {}

    def train(label, data)
      reset_cache
      @total += 1
      @labels[label] += 1
      data.each { |k, v| record label, k, v }
    end

    def prob(key)
      @cache[key] ||= @data.transform_values do |label_records|
                        if label_records[key].respond_to? :totals=
                          label_records[key].totals = totals key
                        end

                        label_records[key]
                      end
    end

    def labels
      @labels.keys
    end

    def total(key)
      totals(key).values.sum
    end

    def totals(key)
      @data.values.map { _1[key] }
           .compact.map(&:records)
           .inject do |values, other|
             values.merge(other) { |_k, a_val, b_val| a_val + b_val }
           end
    end

    def label_prob(label)
      Rational(@data[label].count, @total)
    end

    # evaluate calculates the probability for each label
    def evaluate(entry)
      labels.zip(labels.map { |label| extract_probablities label, entry })
        .to_h.compact
        # .tap { |result| require 'pry'; binding.pry }
    end

    # classify provides the most likely label for a given entry
    def classify(entry)
      results = evaluate(entry)
      return 'unkown' if results.all? { |_, result| result < THRESHOLD }

      results.to_a.map { |k, v| [k, v || 0] }.sort { |a, b| b[1] <=> a[1] }.dig(0, 0)
    end

    private

    def record(label, key, value)
      init_data_store label, key, value
      @data[label][key] << value
    end

    def init_data_store(label, key, value)
      @data[label] ||= {}

      case value
      when Numeric
        @data[label][key] ||= NumericPrediction.new
      when Hash
        @data[label][key] ||= TextPrediction.new
      when String
        @data[label][key] ||= WordPrediction.new
      else
        raise "Unsupported data type #{value.class} for #{key}"
      end
    end

    def extract_probablities(label, entry)
      probabilities = [1].concat entry.map { |key, val| prob(key)[label][val] }.compact
      raise ProbabilityZeroError if probabilities.any?(&:zero?)

      probabilities.inject(&:*)
    rescue ProbabilityZeroError
      puts "WARN: Probability with value zero detected"
      positive_probs = probabilities.reject(&:zero?)
      positive_probs.inject(&:*) * positive_probs.length / probabilities.length
    end
  end
end
