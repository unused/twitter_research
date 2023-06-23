# frozen_string_literal: true

module TwitterResearch
  module Tasks
    # Export an egocentric network based on followership.
    class EgoExportTask < BaseTask
      ENV_KEY = "EGO"

      Graph = Struct.new(:header, :data) do
        def <<(values) = data << values
        def table = [header].concat(data)
        def to_csv = table.map { |row| row.join(",") }.join("\n")
      end

      class << self
        def name = :ego_export
        def description = "Export a egocentric graph edge list"
      end

      def perform
        raise MissingEnvKeyError, "#{ENV_KEY} not found" unless ENV.key? ENV_KEY

        log "Export nodes\n"
        export_nodes
        log "Export edges\n"
        export_edges
      end

      def export_nodes
        filepath = File.join Storage.directory, "ego-node-list.csv"
        register_total users.count
        CSV.open(filepath, "wb") do |csv|
          csv << %w[Id Username FollowersCount Role]
          users.each do |user|
            tick
            csv << [user.id.to_s, user.username, user.followers_count, user._role]
          end
        end
      end

      def export_edges
        filepath = File.join Storage.directory, "ego-edge-list.csv"
        CSV.open(filepath, "wb") do |csv|
          csv << %w[Source Target]
          register_total users.count
          users.each do |user|
            tick
            if user._follower_ids.empty?
              log "#{user.username} has no followers\n"
              next
            end

            # consider only edges to the network of the ego, no new nodes
            target = user._follower_ids & ego._follower_ids
            source = Array.new(target.length).fill(user.id)
            edges = target.zip source
            edges.each { |edge| csv << edge }
          end
        end
      end

      def users = Database::User.where(:id.in => ego._follower_ids).no_timeout
      def ego = @ego = Database::User.find_by(username: ENV.fetch(ENV_KEY))
    end
  end
end
