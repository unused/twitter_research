# frozen_string_literal: true

module TwitterResearch
  module Database
    # Twitter Tweet Schema to provide attributes for the testsuite and have an
    # overview of given details.
    module TweetSchema
      def self.included(base)
        base.class_eval do
          field :reply_count, type: Integer, default: 0
          field :favorite_count, type: Integer, default: 0
          field :quote_count, type: Integer, default: 0
          field :retweet_count, type: Integer, default: 0
        end
      end
    end
  end
end
