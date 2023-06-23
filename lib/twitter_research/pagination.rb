# frozen_string_literal: true

module TwitterResearch
  # Pagination provides helper to repeat requests until no next (Twitter
  # pagination) token is received.
  #
  # https://developer.twitter.com/en/docs/twitter-api/pagination
  module Pagination
    def with_pagination(params = {})
      result = []

      loop do
        response = yield params
        result.append(*response.data)
        return result unless response.meta&.key? "next_token"

        params["pagination_token"] = response.meta["next_token"]
      end
    end
  end
end
