require_relative './confusion_matrix'
require 'forwardable'

module TwitterResearch
  # A collection of reporting tools for classification.
  class Report
    extend Forwardable

    def initialize(result)
      @confusion_matrix = ConfusionMatrix.new

      # result.each do |prediction, expectations|
      #   expectations.each do |expectation, count|
      #     count.times { @confusion_matrix.add_for expectation, prediction }
      #   end
      # end
    end

    def_delegators :@confusion_matrix, :precision, :recall, :f_measure, :overall_accuracy

    # def precision(label) =

    # recall is the number of relevant documents.
    # def recall =

    # def accuracy ... TODO: tp + tn / total

    # combines precision and recall and is also called the harmonic mean.
    # def f1_score
    #   (2.0 * precision * recall) / (precision + recall)
    # end

    # def to_h
    #   @result.map do |label, matches|
    #       ruby
    #   end.to_h
    # end

    # # count the number of times the label has been identified correctly.
    # def true_positive(label) = @result[label][label]

    # # count the number of times the another label has been identified
    # # correctly.
    # def true_negative(label)
    #   @result.inject(0) do |sum, result|
    #     next sum if label == result[0]
    #     result[1].sum { |key, value| result[0] == key ? value : 0 }
    #   end
    # end

    # # count the number of times, the current label has been detected falsly.
    # def false_positive(label)
    #   @result.inject(0) do |sum, result|
    #     next sum if label == result[0]
    #     result[1].sum { |key, value| label == key ? value : 0 }
    #   end
    # end

    # # count the number of times, the current label has been detected falsly.
    # def false_negative(label)
    #   @result[label].sum { |key, value| label != key ? value : 0 }
    # end
  end
end
