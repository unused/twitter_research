# frozen_string_literal: true

module TwitterResearch
  # User interface to fetch details from Twitter API.
  class User
    FIELDS = %i[created_at description entities id location name
                pinned_tweet_id profile_image_url protected public_metrics url
                username verified withheld].freeze

    class << self
      def find_by_usernames(*usernames)
        raise ArgumentError, "too many arguments, max 100" if usernames.length > 100

        params = { "user.fields": FIELDS.join(",") }
        Request.new("users/by").call(params.merge(usernames:))
      end
    end
  end
end
