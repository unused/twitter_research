# frozen_string_literal: true

module TwitterResearch
  module Tasks
    class EgoExtendTask
      ENV_KEY = 'EGO'.freeze

      class << self
        def name = :ego_extend
        def description = 'Extend followers of an ego'
      end

      def perform = users.each { |user| UserExtend.new(user).() }
      def users = Database::User.where(:id.in => ego._follower_ids)
      def ego = @ego = Database::User.find_by(username: ENV.fetch(ENV_KEY))
    end
  end
end
