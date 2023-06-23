# frozen_string_literal: true

module TwitterResearch
  module Database
    # Information on the collection execution.
    module CollectInfo
      def self.included(base)
        base.class_eval do
          # Collection Information
          field :_collected_at, type: String
          field :_source_file, type: String
          field :_collect_method, type: String
          field :_collect_filter, type: String
        end
      end
    end
  end
end
