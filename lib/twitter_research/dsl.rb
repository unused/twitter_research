# frozen_string_literal: true

module TwitterResearch
  module DSL

  def logger
    @logger ||= Logger.new($stdout).tap do |logger|
      logger.level = ENV.fetch('LOG_LEVEL', 'WARN')
    end
  end

  def stored(_basename, &block)
    with_rate_retry do
      file = Storage.new name
      return if file.exists?

      request = block.call
      raise Error.by_request request unless request.successfull?

      file.write request.body
      request.data
    end
  end

  def with_rate_retry
    yield
  rescue RateLimitError => e
    wait_in_seconds = (e.reset_at - Time.now).abs.to_i + 5
    logger.warn "Rate limit exceeded, wait for #{wait_in_seconds} seconds"
    sleep wait_in_seconds
  end

  def twitter(key) = { user: User, followers: Follower }.fetch key
  end
end
