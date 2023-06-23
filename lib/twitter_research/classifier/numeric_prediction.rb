# frozen_string_literal: true

module TwitterResearch
  # Numeric Predicitions using normalization.
  class NumericPrediction
    def initialize
      @records = []
    end

    def [](val)
      return low_records_result(val) if stdev.nan? || stdev.zero?

      normalized_probablity_for val
    end

    def <<(record)
      @mean = nil
      @stdev = nil

      @records << record
    end

    def mean
      @mean ||= calculate_mean_stdev.first
    end

    def stdev
      @stdev ||= calculate_mean_stdev.last
    end

    private

    def calculate_mean_stdev
      @mean, @stdev = @records.mean_stdev
    end

    def normalized_probablity_for(val)
      (1.0 / (stdev * Math.sqrt(2 * Math::PI))) * \
        Math.exp(-0.5 * (((val - mean) / stdev)**2))
    end

    def low_records_result(val)
      @records.uniq == [val] ? 1.0 : nil
    end
  end
end
