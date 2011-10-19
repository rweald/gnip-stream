module GnipStream
  class DataBuffer 
    attr_accessor :pattern
    def initialize(pattern)
      @pattern = pattern
      @buffer = ""
    end

    def process(chunk)
      @buffer.concat(chunk)
    end

    def complete_entries
      entries = []
      while (match_data = @buffer.match(@pattern))
        entries << match_data.captures[0]
        @buffer = match_data.captures[1]
      end
      entries
    end
  end
end
