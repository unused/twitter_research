# frozen_string_literal: true

module TwitterResearch
  # Generic error, can choose an error by HTTP status.
  class Error < StandardError
    def self.by_request(req)
      {
        # 400 => ConnectionError,
        429 => RateLimitError.new(req)
      }.fetch(req.code) { new "Unkown error for http status #{req.code}" }
    end
  end

  # The configuration is missing required arguments.
  class ConfigError < StandardError; end

  # A environment key was expected but is not present.
  class MissingEnvKeyError < StandardError; end

  # It seems there has been a problem with the network connection.
  class ConnectionError < StandardError; end

  # In case we exceed any Twitter API limits a RateLimitError will be raised.
  # It provides the timestamp `reset_at` that can be used to calculate the
  # amount of time we have to get unblocked. Additionally the information on
  # the current endpoints request limit per fifteen minutes is stored in
  # `endpoint_limit_by_fifteen_minutes`.
  #
  # https://developer.twitter.com/en/docs/twitter-api/rate-limits
  class RateLimitError < StandardError
    attr_reader :reset_at, :endpoint_limit_by_fifteen_minutes

    def initialize(req)
      headers = req.response.headers # req.code == 429
      @reset_at = Time.at headers["x-rate-limit-reset"].to_i
      @endpoint_limit_by_fifteen_minutes = headers["x-rate-limit-limit"].to_i

      super
    end

    def message = "Rate limit exceeded, wait until #{@reset_at}"
  end

  # Classifier must not contain (sub)results with probability zero.
  class ProbabilityZeroError < StandardError; end
end
