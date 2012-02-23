require 'yajl'
module GnipStream
  class GzippedJSONBuffer
    def initialize
      @buffer_cursor = 0
      @header = nil
      @gzip = nil
      @json_parser = 
    end

    def process(chunk)
      #compressed_string = StringIO.new(chunk)
      #compressed_string.each_byte { |b| puts "byte: #{b.chr}" }
      data_len = chunk.length

      if @buffer_cursor == 0
        puts "creating headers\n\n"
        @header = chunk
        @buffer = StringIO.new(chunk)
        @buffer_cursor += @buffer.length
        @gzip = Zlib::GzipReader.new(@buffer)
        return
      end

      if @buffer.length < 3000
        puts "buffering for gzip content\n\n"
        @buffer.write(chunk)
      else
        @buffer.write(chunk)
        @buffer.seek(@buffer_cursor)
        puts @gzip.readpartial(@buffer.length - 1)
        reset_buffer
      end
    end

    def reset_buffer
      @buffer_cursor = 10
      @buffer = StringIO.new(@header)
      @gzip = Zlib::GzipReader.new(@buffer)
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
