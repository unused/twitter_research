# frozen_string_literal: true

require_relative "./user_schema"

module TwitterResearch
  module Database
    # Database user collection.
    class User
      include Mongoid::Document
      include Mongoid::Attributes::Dynamic
      include UserSchema
      include CollectInfo

      # normalized fields
      field :_username, type: String
      field :_description, type: String
      field :_website, type: String

      field :_fetch_error, type: String

      field :_label, type: String
      # multi-label support
      field :_labels, type: Array

      # Define the types of labels that have been manually applied to this
      # user.
      field :_labeled, type: Array, default: []

      # User role (streamer, game, etc.)
      field :_role, type: String

      # legacy field
      field :_detected_language, type: String
      # legacy field
      field :_categories, type: Array

      field :_eigenvector_centrality, type: Float
      field :_pagerank_centrality, type: Float
      field :_betweeness_centrality, type: Float

      field :_follower_ids, type: Array, default: []
      field :_created_at, type: Time
      field :_imported_at, type: Time, default: -> { Time.now.utc }

      field :_monthly_average_tweet_count, type: Integer

      # field :friend_ids, type: Array
      # has_many :_friends

      def self.labeled(kind) = where(:_labeled.in => [kind])

      def self.random
        instantiate collection.aggregate([{ "$sample": { size: 1 } }]).first
      end

      def websites
        return [] unless respond_to? :entities

        combined_urls
          &.select { |url| url.key? "expanded_url" }
          &.map do |url|
            URI(url.fetch("expanded_url")).host
          rescue URI::InvalidURIError
            url.fetch("expanded_url").split("/")[2]
          end
      end

      def combined_urls
        Array(entities.dig("url", "urls")).concat \
          Array(entities.dig("description", "urls"))
      end

      # Followers count, backward compatible to API V1.1
      def followers_count
        self[:followers_count] || public_metrics["followers_count"]
      end

      # Followers count, backward compatible to API V1.1
      def following_count
        self[:friends_count] || public_metrics["following_count"]
      end

      # Tweets count, backward compatible to API V1.1
      def tweet_count
        self[:tweet_count] || public_metrics["tweet_count"]
      end

      def followers_ratio = Rational(followers_count, following_count).to_f
    end
  end
end
