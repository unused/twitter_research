# frozen_string_literal: true

require "json"

module TwitterResearch
  module Tasks
    # Export a hashtag co-occurrence network with all given tweets.
    class HashtagCoOccurenceTask < BaseTask
      Graph = Struct.new(:data) do
        def initialize = super(data: [])
        def header = %w[Source Target Weight]
        def table = [header].concat(data)

        def <<(tags)
          tags.combination(2).each { |combination| add_edge(*combination) }
        end

        def to_csv = table.map { |row| row.join(",") }.join("\n")

        def add_edge(source, target)
          index = find_index source, target
          if index
            data[index][2] += 1
          else
            data << [source, target, 1]
          end
        end

        def find_index(*key) = data.index { |row| row[..1] == key }
      end

      class << self
        def name = :hashtag_co_occurrence
        def description = "Get all co-occurence hashtags"
      end

      def perform
        graph = Graph.new
        register_total tweets.count
        add_hashtags graph
        File.write target_file, graph.to_csv
      end

      private

      def add_hashtags(graph)
        hashtags.each do |tags|
          graph << tags.map(&:downcase)
          tick
        end
      end

      def target_file = "#{Storage.directory}/hashtag-co-occurrence.csv"
      def hashtags = tweets.pluck("entities.hashtags.text").compact
      def tweets = Database::Tweet.no_retweets.where(:"entities.hashtags".ne => [])
    end
  end
end
