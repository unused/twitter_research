# frozen_string_literal: true

module TwitterResearch
  # A classifier that takes values and assigns labels by occurrence of static
  # content.
  class StaticClassifier
    KLASSES = {
      'streamer' => %w[twitch streamer],
      'indie-dev' => ['indiedev', 'indie-dev'],
      'indie-studio' => ['indie-studio', 'indie studio', 'indiestudio'],
      'indie-game' => ['indiegame', 'indie-game', 'indie game'],
      'indie-artist' => ['indiegame', 'indie-game', 'indie game'],
      'gamer' => ['gamer', 'play games'],
      'game-dev' => ['gamedev', 'game-dev', 'unity', 'unreal engine', 'ue4', 'ue5'],
      'game-publisher' => ['game publisher', 'game-publisher', 'publish games'],
      'game' => ['game']
    }.freeze

    def classify(entry)
      words = (entry[:description_words].keys << entry[:website]).join ' '

      KLASSES.each do |label, word_list|
        return label if word_list.any? { |word| words.include? word }
      end
      'unknown'
    end
  end
end
