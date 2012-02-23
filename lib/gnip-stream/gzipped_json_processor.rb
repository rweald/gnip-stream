require 'gnip-stream/gzip_processor'
require 'yajl'

module GnipStream
  class GzippedJSONParser
    def initialize
      @complete_entries = []
      setup_gzip_processor
      setup_json_parser
    end

    def process(compressed_chunk)
      @gzip_processor << compressed_chunk
    end

    def handle_uncompressed_chunk(json_chunk)
      @json_parser << json_chunk
    end

    def handle_complete_json_entry(json_entry)
      @complete_entries << json_entry
    end

    def complete_entries
      current_complete_entries = @complete_entries
      @complete_entries = []
      current_complete_entries
    end

    private
    def setup_gzip_processor
      @gzip_processor = GnipStream::GzipProcessor.new
      @gzip_processor.on_uncompressed_chunk = method(:handle_uncompressed_chunk)
    end

    def setup_json_parser
      @json_parser = Yajl::Parser.new
      @json_parser.on_parse_complete = method(:handle_complete_json_entry)
    end
  end
end
