require 'eventmachine'
require 'em-http-request'

module GnipStream
  class Stream

    attr_accessor :headers, :options, :url, :username, :password

    def initialize(url, processor, headers={})
      @url = url
      @headers = headers
      @error_handler = Object.new
      @processor = processor
    end

    def on_message(&block)
      @on_message = block
    end

    def on_connection_close(&block)
      @on_connection_close = block
    end

    def on_error(&block)
      @on_error = block
    end

    def connect
      http = EM::HttpRequest.new(@url).get :inactivity_timeout => 0, :headers => @headers
      http.chunk { |chunk| process_chunk(chunk) }
      http.callback { handle_connection_close(http) }
      http.errback { handle_error(http) }
    end

    def process_chunk(chunk)
      @processor.process(chunk)
      @processor.complete_entries.each do |entry| 
        EM.defer { @on_message.call(entry) }
      end
    end

    def handle_error(http_connection)
      @on_error.call(http_connection)
    end

    def handle_connection_close(http_connection)
      @on_connection_close.call(http_connection)
    end

  end
end
