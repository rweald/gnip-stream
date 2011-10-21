require 'gnip-stream/powertrack_authentication'
module GnipStream
  class PowertrackClient
    def initialize(url, username, password)
      @authentication = PowertrackAuthentication.new(url, username, password)
      @stream = JsonStream.new(url)
      @error_handler = ErrorReconnect.new(self, :consume)
      @connection_close_handler = ErrorReconnect.new(self, :consume)
      configure_handlers
    end

    def configure_handlers
      @stream.on_error { |error| @error_handler.attempt_to_reconnect("Gnip Connection Error. Reason was: #{error.inspect}") }
      @stream.on_connection_close { @connection_close_handler.attempt_to_reconnect("Gnip Connection Closed") }
    end

    def consume(&block)
      @client_callback = block
      @stream.on_message(&@client_callback)
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
