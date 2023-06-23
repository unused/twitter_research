# frozen_string_literal: true

require "json"

module TwitterResearch
  module Tasks
    class ImportTweetsTask
      class << self
        def name = :import_tweets
        def description = 'Import Tweet JSONL files from ENV["IMPORT_DIR"]'
      end

      def perform
        Storage.tweet_files.each { |file| import_file file }
      end

      private

      def create_tweet_from(json_line)
        unless json_line[0] == "{"
          json_line = json_line.split("{").last
          create_tweet_from json_line if json_line[0] == "{" # second chance

          return
        end

        tweet = JSON.parse json_line
        print(Database::Tweet.new(tweet.to_h).save ? "." : "x")
      rescue Mongo::Error::OperationFailure => e
        puts "[ERR] Failed to save tweet: #{e}"
      rescue JSON::ParserError => e
        puts "[ERR] Failed to parse line... #{String(e).slice(0, 50)}"
      end

      def import_file(file)
        return if Database::ImportLog.where(file:).exists?

        print "\n[INFO] Import file #{file}: "
        File.readlines(file.filepath).each { |line| create_tweet_from line }
        Database::ImportLog.create(file:)
      end
    end
  end
end
