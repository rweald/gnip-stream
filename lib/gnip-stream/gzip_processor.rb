require 'zlib'

module GnipStream
  class GzipProcessor
    attr_accessor :on_uncompressed_chunk
    attr_reader :gzip_header
    attr_reader :buffer

    def initialize
      @buffer = ""
    end

    def push(compressed_chunk)
      if @gzip_header.nil?
        @gzip_header = compressed_chunk[0..9]
        compressed_chunk = compressed_chunk[10..-1]
      end

      @buffer += compressed_chunk

      if @buffer.length > 2050
        decompress_buffer
      end
    end

    def <<(compressed_chunk)
      push(compressed_chunk)
    end

    private
    def decompress_buffer
      io_buffer = StringIO.new(@gzip_header + @buffer)
      gzip_reader = Zlib::GzipReader.new(io_buffer)
      io_buffer.seek(@gzip_header.length)
      
      uncompressed_data = gzip_reader.readpartial(@buffer.length)
      @on_uncompressed_chunk.call(uncompressed_data)
      @buffer = ""
    end
  end
end
