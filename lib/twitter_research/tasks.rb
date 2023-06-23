# frozen_string_literal: true

module TwitterResearch
  # Task for processing information.
  module Tasks
    def self.tasks = constants.map { |name| const_get name }
  end
end
