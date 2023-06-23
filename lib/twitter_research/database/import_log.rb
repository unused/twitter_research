# frozen_string_literal: true

module TwitterResearch
  module Database
    # Database import log entries.
    class ImportLog
      include Mongoid::Document
      include Mongoid::Timestamps::Created

      field :file, type: String
    end
  end
end
