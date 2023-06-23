# frozen_string_literal: true

require_relative "./tweet_schema"

module TwitterResearch
  module Database
    # Database tweet collection.
    class Tweet
      include Mongoid::Document
      include Mongoid::Attributes::Dynamic
      include TweetSchema
      include CollectInfo

      # field :_user_extracted, type: Boolean, default: false
      # field :_detected_language, type: String

      field :_sentiment, type: String

      field :_hashtags, type: Array
      field :_websites, type: Array
      field :_created_at, type: Time
      field :_imported_at, type: Time, default: -> { Time.now.utc }

      scope :no_retweets, -> { where retweeted_status: nil }

      # index({ retweet_count: 1 }, background: true)
      # index({ favourite_count: 1 }, background: true)
      # index({ _tags: 1 }, background: true)
      # index({ _user_extracted: 1 }, background: true)
      # index({ _detected_language: 1 }, background: true)

      def self.random
        instantiate collection.aggregate([{ "$sample": { size: 1 } }]).first
      end

      def hashtags
        return [] unless respond_to? :entities

        Array(entities.dig("hashtags", "tag"))
      end

      def websites
        return [] unless respond_to? :entities

        Array(entities.dig("url", "urls")).map do |url|
          URI(url.fetch("expanded_url")).host
        end
      end
    end
  end
end
