# frozen_string_literal: true

module TwitterResearch
  module Database
    # Twitter User Schema to provide attributes for the testsuite and have an
    # overview of given details.
    module UserSchema
      def self.included(base)
        base.class_eval do
          field :name, type: String
          field :username, type: String
          field :description, type: String
          field :url, type: String
          field :public_metrics, type: Hash
        end
      end
    end
  end
end
