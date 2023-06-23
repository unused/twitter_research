# frozen_string_literal: true

require "stopwords"
require "stemmify"

module TwitterResearch
  # Prepare text for classification by downcasing, removing non-alphabetical
  # characters, removing stopwords, stemming and tallying the words.
  class TextTransformer
    attr_accessor :text

    def initialize(text = "")
      @text = text
    end

    def words
      @text.downcase.scan(/[a-z]+/)
    end

    def filtered
      stopwords.filter(lang: :en, words:)
    end

    def stemmed
      filtered.map(&:stem)
    end

    def tally
      # stemmed.tally
      filtered.tally
    end

    private

    def stopwords
      Stopwords::Snowball::WordSieve.new
    end
  end
end
