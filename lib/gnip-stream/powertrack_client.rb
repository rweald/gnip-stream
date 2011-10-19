require 'gnip-stream/powertrack_authentication'
module GnipStream
  class PowertrackClient
    def initialize(url, username, password)
      @authentication = PowertrackAuthentication.new(url, username, password)
      @stream = JsonStream.new(url)
      configure_handlers
    end

    def configure_handlers
      @stream.on_error { |error| raise "Gnip Connection Error. Reason was: #{error.inspect}" }
      @stream.on_connection_close { raise "Gnip Connection Closed" }
    end

    def consume(&block)
      @stream.on_message(&block)
      authenticate
      @stream.connect
    end

    def authenticate
      @authentication.authenticate
      @stream.url = @authentication.location
      @stream.headers = {"cookie" => @authentication.cookies}
    end

  end
end
