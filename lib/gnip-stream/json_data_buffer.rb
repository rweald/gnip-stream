module GnipStream
  class JsonDataBuffer 
    attr_accessor :split_pattern
    def initialize(split_pattern)
      @split_pattern = split_pattern
      @buffer = ""
    end

    def process(chunk)
      @buffer.concat(chunk)
    end

    def complete_entries
      entries = []
      while line = @buffer.slice!(split_pattern)
        entries << line
      end
      entries
    end
  end
end
