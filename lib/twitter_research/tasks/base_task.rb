# frozen_string_literal: true

require "json"

module TwitterResearch
  module Tasks
    # Export a hashtag co-occurrence network with all given tweets.
    class BaseTask
      def log(msg) = print "[#{Time.now.utc}] #{msg}"

      def register_total(total) = @progress = Progress.new.tap { _1.total = total }
      def tick = @progress.tick
    end
  end
end
