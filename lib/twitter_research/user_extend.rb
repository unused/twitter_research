# frozen_string_literal: true

module TwitterResearch
  # User extend applies pre processing on at given record.
  class UserExtend
    ACTIONS = %i[normalize_username normalize_description normalize_website
                 set_created_at store_followers_ratio classify
                 monthly_average_tweet_count].freeze
    Wrap = Struct.new(:user) do
      def username = user.username.downcase
      def description = user.description.downcase.gsub(/[^0-9a-z# ]/, '')
      def ratio = (user.following_count.positive? ? user.followers_count.to_f / user.following_count : 0.0)
      def website = user.websites&.first.to_s
      def created_at = Time.parse(user.created_at)

      def monthly_average_tweet_count
        user.tweet_count / [(user.created_at - Time.now.utc).months, 1].max
      end
    end

    def initialize(user)
      @wrap = Wrap.new(user)
    end

    class << self
      def unprocessed_users = Database::User.where(_followers_ratio: nil)
    end

    def user = @wrap.user

    def call
      ACTIONS.each { |process| public_send process }

      # pp [user._role, @wrap.website, user._description]
      user.save!
    end

    def normalize_username = user.write_attribute :_username, @wrap.username
    def normalize_description = user.write_attribute :_description, @wrap.description
    def normalize_website = user.write_attribute :_website, @wrap.website
    def store_followers_ratio = user.write_attribute :_followers_ratio, @wrap.ratio
    def set_created_at = user.write_attribute :_created_at, @wrap.created_at
    def classify = user.write_attribute :_role, classifier.classify(role_attributes(user))

    def monthly_average_tweet_count
      user.write_attribute :_monthly_average_tweet_count, @wrap.monthly_average_tweet_count
    end

    def classifier = @classifier ||= static_classifier

    private

    # NOTE: websites: Array(role_user.websites).tally,
    def role_attributes(role_user)
      wrapped_user = Wrap.new role_user

      { website: wrapped_user.website, # followers_ratio: wrapped_user.ratio,
        description_words: TwitterResearch::TextTransformer.new(wrapped_user.description).tally }
    end

    def static_classifier = StaticClassifier.new

    def bayes_classifier
      Bayes.new.tap do |bayes|
        labeled_users.each do |labeled_user|
          bayes.train labeled_user._role, role_attributes(labeled_user)
        end
      end
    end

    def labeled_users = Database::User.labeled("role")
  end
end
