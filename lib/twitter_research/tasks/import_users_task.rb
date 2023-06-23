# frozen_string_literal: true

require 'json'

module TwitterResearch
  module Tasks
    class ImportUsersTask
      class << self
        def name = :import_users
        def description = 'Import User JSON files from ENV["IMPORT_DIR"]'
      end

      def perform
        import_users
        import_followers
      end

      private

      def import_users
        Storage.user_files.each do |file|
          create_user file.content, file.basename

          _, username = File.split file.basename
          followers_file = Storage.new(File.join('followers', username))
          import_followers_file followers_file if followers_file.exist?
        end
      end

      def create_user(user_data, filename = 'unknown')
        user_data = user_data.first if user_data.is_a? Array # ???
        user_data = user_data.merge metadata(filename)
        return if Database::User.where(id: user_data['id']).exists?

        print (Database::User.new(user_data).save ? '.' : 'x')
      rescue Mongo::Error::OperationFailure => err
        puts "[ERR] Failed to save user: #{err}"
      rescue JSON::ParserError => err
        puts "[ERR] Failed to parse line... #{String(err).slice(0, 50)}"
      end

      def metadata(filename)
        { _source_file: filename, _collect_method: 'REST API' }
      end

      def import_followers
        Storage.follower_files.each { |file| import_followers_file file }
      end

      def import_followers_file(file)
        update_follower_ids file

        file.content.each do |user|
          create_user user, file.basename
        end
      rescue Mongoid::Errors::DocumentNotFound => err
        puts "[ERR] Failed to find user: #{err}"
      rescue Mongo::Error::OperationFailure => err
        puts "[ERR] Failed to update user: #{err}"
      rescue JSON::ParserError => err
        puts "[ERR] Failed to parse friends... #{file}"
      end

      def update_follower_ids(file)
        _, username = File.split file.basename
        follower_ids = file.content.pluck('id')
        Database::User.find_by(username:).update!(_follower_ids: follower_ids)
      end
    end
  end
end
