# frozen_string_literal: true

module TwitterResearch
  module Tasks
    class EgocentricTask
      ENV_KEY = 'EGO'.freeze

      class RequestFailedError < StandardError
        attr_reader :request

        def initialize(req)
          @request = req
          super
        end
      end

      class << self
        def name = :egocentric
        def description = 'Fetch egocentric network from USERNAME'
      end

     def perform
        raise MissingEnvKeyError, "#{ENV_KEY} not found" unless ENV.key? ENV_KEY
        @username = ENV.fetch ENV_KEY

        remove_broken_files
        retry_empty_follower_files

        fetch_base_user
        fetch_follower_users
      end

      def log(msg) = puts "[#{Time.now}] #{msg}"

      def fetch_base_user
        once "users/#{@username}" do |file|
          log "Fetch base user profile #{file.name}"
          # TODO: why return an array on this one!?
          req = TwitterResearch::User.find_by_usernames(file.name)
          check_response! req
          file.write req.data
          fetch_followers @username, req.data.first["id"]
        end
        fix_on_broken_fetch_followers
      end

      def fix_on_broken_fetch_followers
        return if Storage.new("followers/#{@username}").exist?

        req = Storage.new("users/#{@username}").content
        fetch_followers @username, req.first["id"]
      end

      def fetch_follower_users
        filename = "followers/#{@username}"
        followers = Storage.new(filename).content
        followers.each do |follower|
          if follower['protected']
            log "User #{follower['username']} is protected"
            next
          end

          fetch_followers follower['username'], follower['id']
        end
      end

      def once(name)
        file = TwitterResearch::Storage.new name
        return if file.exist?

        yield file
      rescue RequestFailedError => e
        t = Time.at e.request.response.headers['x-rate-limit-reset'].to_i
        wait_in_seconds = (t - Time.now).abs.to_i + 5
        log "Request failed for #{name}, wait for #{wait_in_seconds} seconds"
        sleep wait_in_seconds
        retry
      end

      def fetch_followers(name, id)
        once "followers/#{name}" do |file|
          log "Fetch followers for #{name}"
          file.write TwitterResearch::Follower.find id

          # we have a limit of 15 requests per minute per follows lookup... we
          # need to wait.
          sleep 60
        end
      end

      def check_response!(req)
        return true if req.successfull?

        raise RequestFailedError, req
      end

      def remove_broken_files
        data_dir = TwitterResearch::Storage.directory
        Dir.glob(File.join(data_dir, 'users', '*.json')).each do |file|
          json = JSON.parse File.read file
          next if json.is_a?(Array) || json.dig('status')&.to_i != 429

          log "Delete broken 429 - #{file}"
          File.delete file
        rescue JSON::ParserError
          puts "[ERR] Failed to parse #{file}"
        end
      end

      def retry_empty_follower_files
        Storage.follower_files.each do |file|
          log "Would rm #{file}" if file.content.empty?
          # File.delete file.filepath if file.content.empty?
        rescue JSON::ParserError
          puts "[ERR] Failed to parse #{file}"
        end
      end
    end
  end
end
