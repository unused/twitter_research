# frozen_string_literal: true

module TwitterResearch
  # The file based storage provides a shortened interface and ensures the
  # contents are kept in the data directory. Overwrite of content is simply
  # skipped. The body of an existing file is expected to be present in JSON
  # format, such that it is parsed on content request.
  class Storage
    attr_accessor :basename, :filetype
    alias name basename

    def initialize(basename, filetype = "json")
      self.basename = basename
      self.filetype = filetype
    end

    class << self
      attr_accessor :directory

      def user_files = files_lookup("users")
      def follower_files = files_lookup("followers")
      def tweet_files = files_lookup("tweets", "jsonl")

      private

      def files_lookup(path, filetype = "json")
        Dir.glob(File.join(directory, path, "*.#{filetype}")).map do |file|
          new File.join(path, File.basename(file, ".#{filetype}")), filetype
        end
      end
    end

    def filename = "#{basename}.#{filetype}"

    def filepath = File.join self.class.directory, filename
    alias to_s filepath

    def exist? = File.exist? filepath

    def write(content)
      return false if exist?

      @content = content
      File.write filepath, @content.to_json
    end

    def content
      @content ||= JSON.parse File.read filepath
    end
  end
end
