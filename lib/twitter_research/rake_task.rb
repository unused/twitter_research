# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'

require 'twitter_research'

# Import all files from tasks directory.
Dir.glob("#{__dir__}/tasks/*.rb").each { |file| require_relative file }

module TwitterResearch
  # Register a Rake task.
  #
  #   require 'twitter_research/rake_task'
  #
  #   # Register the twitter_research namespace
  #   TwitterResearch::RakeTask.new
  #   # Set a custom Rake namespace
  #   TwitterResearch::RakeTask.new(:twittr)
  #   # Adapt configuration
  #   TwitterResearch::RakeTask.new do |config|
  #     config.verbose = false
  #   end
  class RakeTask < ::Rake::TaskLib
    Config = Struct.new(:verbose)

    def initialize(name = :twitter_research, *args, &task_block)
      @config = Config.new true
      yield @config if block_given?
      namespace(name) { setup_subtasks(name, *args, &task_block) }
    end

    private

    def setup_subtasks(name, *args, &task_block)
      subtasks.each do |task|
        next unless task.respond_to? :description

        desc task.description
        task(task.name, *args) do |_, task_args|
          RakeFileUtils.verbose(@config.verbose) do
            yield(*[self, task_args].slice(0, task_block.arity)) if task_block
            task.new.perform
          end
        end
      end
    end

    def subtasks = Tasks.tasks
  end
end
