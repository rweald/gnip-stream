module GnipStream
  class JsonDataBuffer 
    attr_accessor :split_pattern, :check_pattern
    def initialize(split_pattern, check_pattern)
      @split_pattern = split_pattern
      @check_pattern = check_pattern
      @buffer = ""
    end

    def process(chunk)
      @buffer.concat(chunk)
    end

    def complete_entries
      entries = []
      while @buffer =~ check_pattern
        activities = @buffer.split(split_pattern)
        entries << activities.shift
        @buffer = activities.join('')
      end

      entries
    end
  end
end
