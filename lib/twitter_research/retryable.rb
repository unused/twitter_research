# frozen_string_literal: true

module TwitterResearch
  # Retryable will retry on a rate limit exceed.
  module Retryable
    def with_limit_retry
      return unless yield.code == 423

      # TODO: logger...
      puts "Rate limit exceeded, wait for #{wait_in_seconds} seconds"
      sleep wait_in_seconds
      with_limit_retry
    end

    def wait_in_seconds
      (rate_limit_reset_at - Time.now).abs.to_i + 5
    end

    def rate_limit_reset_at
      Time.at response.headers["x-rate-limit-reset"].to_i
    end
  end
end
