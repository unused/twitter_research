# frozen_string_literal: true

require_relative "./twitter_research/version"
require_relative "./twitter_research/errors"

require_relative "./twitter_research/progress"
require_relative "./twitter_research/pagination"
require_relative "./twitter_research/retryable"
require_relative "./twitter_research/request"
require_relative "./twitter_research/storage"
require_relative "./twitter_research/tweet_extend"
require_relative "./twitter_research/user"
require_relative "./twitter_research/user_extend"
require_relative "./twitter_research/follower"

# Load classification
require_relative "./twitter_research/classifier"

# Load task management.
require_relative "./twitter_research/tasks"

# DSL
require_relative "./twitter_research/dsl"

# Twitter Research is a collection of tools and processes to collect and
# analyze data from Twitter API V2.
module TwitterResearch
  CONFIG_FILENAME = "twitter-research.yml"

  class << self
    # Look for the config file dot-hidden in current directory or in home
    # config directory.
    def configure!(filename = "./.#{CONFIG_FILENAME}")
      read_config(filename) \
        || read_config(File.join(Dir.home, '.config', CONFIG_FILENAME)) \
        || raise_config_error
    end

    def read_config(file)
      return unless File.exist? file

      YAML.safe_load_file(file).each do |key, value|
        next unless respond_to? :"#{key}="

        public_send :"#{key}=", value
      end

      true
    end

    def data_directory=(path)
      Storage.directory = path
    end

    def api_token=(token)
      Request.api_token = token
    end

    # Database extension must be loaded exclusively, so we skip configuration
    # part if it has not been required.
    def mongodb=(config)
      return unless defined? Database

      Database.configure config
    end

    private

    def raise_config_error
      raise ConfigError, "Could not find or read configuration file"
    end
  end
end
