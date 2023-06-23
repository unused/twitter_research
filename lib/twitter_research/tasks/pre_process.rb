# frozen_string_literal: true

module TwitterResearch
  module Tasks
    # Pre Process Task takes users and tweets that have not been pre-processed
    # and apply extends.
    class PreProcess
      class << self
        def name = :pre_process
        def description = "Pre-process users and tweets in database"
      end

      def perform
        process_users
        process_tweets
      end

      def process_users
        UserExtend.unprocessed_users.each do |user|
          UserExtend.new(user).call
          print "."
        end
      end

      def process_tweets
        TweetExtend.unprocessed_tweets.each do |tweet|
          TweetExtend.new(tweet).call
          print "."
        end
      end
    end
  end
end
