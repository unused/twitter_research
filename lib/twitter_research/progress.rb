# frozen_string_literal: true

module TwitterResearch
  # progress provides nice output to check if a process has been stuck or is
  # running slowly.
  class Progress
    attr_writer :step, :total

    def initialize(output: Kernel.method(:print).to_proc)
      @output = output
      @count = 0
      @step = 100
    end

    def tick
      return " #{stats} " if ((@count += 1) % @step).zero?

      @output.call(".")
    end

    def stats
      return @output.call(" #{@count} ") unless @total

      @output.call(" #{@count}/#{@total} ")
    end

    def reset
      @count = 0
    end
  end
end
