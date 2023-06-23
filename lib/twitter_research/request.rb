# frozen_string_literal: true

require "uri"
require "httparty"

module TwitterResearch
  # Request executes a API request and stores the response.
  class Request
    include Retryable

    @base_uri = "api.twitter.com"

    attr_reader :path, :response

    def initialize(path)
      @url = URI("https://#{self.class.base_uri}/2/#{path}")
    end

    class << self
      attr_accessor :api_token, :base_uri

      def get(path, params = {})
        new(path).call(params)
      end
    end

    def call(params = {})
      @url.query = URI.encode_www_form params
      with_limit_retry { @response = HTTParty.get(@url, headers:) }

      self
    end

    def successfull? = (200..204).cover?(@response&.code) && !to_h.key?("errors")

    def body
      @response&.body&.tap do |body|
        next unless ENV["DEBUG"]

        request_log_file = File.join(__dir__, "..", "..", "log", "request.log")
        File.write request_log_file, body
      end
    end

    def to_h = @to_h ||= JSON.parse(body || "{}")

    # we could check for key, but we want to limit access to those three
    # properties.
    def method_missing(method_name, ...)
      return to_h[method_name.to_s] if %i[data meta errors].include? method_name

      super
    end

    def respond_to_missing?(method_name, include_private: false)
      %i[data meta errors].include?(method_name) || super
    end

    private

    def headers = { Authorization: "Bearer #{self.class.api_token}" }
  end
end
