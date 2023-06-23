# frozen_string_literal: true

module TwitterResearch
  # Interface to fetch followers.
  class Follower
    MAX_RESULTS = 1000
    USER_FIELDS = %i[created_at description entities id location name url
                     pinned_tweet_id profile_image_url protected public_metrics
                     username verified withheld].freeze

    extend Pagination

    class << self
      def find(id)
        params = {
          max_results: MAX_RESULTS,
          "user.fields": USER_FIELDS.join(",")
        }

        with_pagination(params) do |request_params|
          Request.new("users/#{id}/followers").call(request_params)
        end
      end

      def raise_on_error
        yield.tap do |req|
          raise RequestFailedError, req unless req.successfull?
        end
      end

      def with_retry
        yield
      rescue RequestFailedError
        t = Time.at err.request.response.headers["x-rate-limit-reset"].to_i
        wait_in_seconds = (t - Time.now).abs.to_i + 5
        puts "Rate limit exceeded, wait for #{wait_in_seconds} seconds"
        sleep wait_in_seconds
        retry
      end
    end
  end
end
