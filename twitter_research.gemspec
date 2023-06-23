# frozen_string_literal: true

require_relative "lib/twitter_research/version"

Gem::Specification.new do |spec|
  spec.name = "twitter_research"
  spec.version = TwitterResearch::VERSION
  spec.authors = ["Christoph Lipautz"]
  spec.email = ["christoph@lipautz.org"]

  spec.summary = "Collect and Analyze Twitter Data using Ruby"
  spec.description = <<~DESCR
    A data mining tool that provides convienient methods to gather and analyze
    Twitter data using Ruby and Twitter API V2.
  DESCR
  spec.homepage = "https://github.com/unused/twitter_research"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "https://rubygems.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released. The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Register web request framework HTTParty
  spec.add_dependency "httparty", "~> 0.20.0"
  # Add math helpers for standard deviation, mean, normalization, etc.
  spec.add_dependency "enumerable-statistics", "~> 2.0"
  spec.add_dependency "normal_distribution", "~> 0.2.0"
  # Add minimalistic web framework sinatra to host a local labeling client
  spec.add_dependency "puma", "~> 6.0"
  spec.add_dependency "sinatra", "~> 3.0"
  # Register a stopwords provider. Note that this is a fork from the original
  # gem, as this seems to no longer be maintained and has warnings.
  spec.add_dependency "stopwords-filter2", "~> 0.1.0"
  # Add a stem library to avoid re-implementation of steming and other text
  # manipulation.
  spec.add_dependency "stemmify", "~> 0.0.2"
  # Sentiment analysis
  spec.add_dependency "sentimental", "~> 1.5.0"
  # Depends on MongoDB driver Mongoid.
  spec.add_dependency "mongoid", "~> 8.0.3"
  spec.metadata["rubygems_mfa_required"] = "true"
end
