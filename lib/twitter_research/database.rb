# frozen_string_literal: true

require "mongoid"

require_relative "./database/collect_info"
require_relative "./database/user"
require_relative "./database/tweet"
require_relative "./database/import_log"

module TwitterResearch
  # Handle database records.
  #
  # require "twitter_research"
  # require "twitter_research/database"
  #
  # TwitterResearch.configure
  module Database
    class << self
      def configure(default_config)
        default_config.transform_keys!(&:to_sym)
        Mongoid.configure { |config| config.clients.default = default_config }
      end
    end
  end
end
