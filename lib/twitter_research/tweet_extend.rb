# frozen_string_literal: true

module TwitterResearch
  # Tweet extend applies pre processing on at given record.
  class TweetExtend
    ACTIONS = %i[extract_websites extract_hashtags set_created_at
                 sentiment].freeze

    Wrap = Struct.new(:tweet) do
      def created_at = Time.parse(tweet.created_at)
      def websites = tweet.websites
    end

    def initialize(tweet)
      @wrap = Wrap.new(tweet)
    end

    class << self
      def unprocessed_tweets = Database::Tweet.where(_created_at: nil)
    end

    def tweet = @wrap.tweet

    def call
      ACTIONS.each { |process| public_send process }

      tweet.save!
    end

    def extract_websites = tweet.write_attribute :_websites, @wrap.websites
    def extract_hashtags = tweet.write_attribute :_hashtags, @wrap.hashtags
    def set_created_at = tweet.write_attribute :_created_at, @wrap.created_at

    def sentiment
      return unless defined? Sentimental

      tweet.write_attribute :_sentiment, Sentimental.new.sentiment(tweet.text)
    end
  end
end
