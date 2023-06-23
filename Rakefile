# frozen_string_literal: true

require "bundler/gem_tasks"
require "bundler/setup"

require "rspec/core/rake_task"
desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ["--display-cop-names"]
end

require "twitter_research"
require "twitter_research/database"
require "twitter_research/rake_task"
TwitterResearch.configure!
TwitterResearch::RakeTask.new

task default: %i[spec rubocop]
