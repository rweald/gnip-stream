require 'gnip-stream/xml_stream'

module GnipStream
  class FacebookClient
    def initialize(url, username, password)
      @stream = XmlStream.new(url, "authorization" => [username, password])
      @error_handler = ErrorReconnect.new(self, :consume)
      @connection_close_handler = ErrorReconnect.new(self, :consume)
      configure_handlers
    end

    def configure_handlers
      @stream.on_error { |error| @error_handler.attempt_to_reconnect("Gnip Connection Error. Reason was: #{error.inspect}") }
      @stream.on_connection_close { @connection_close_handler.attempt_to_reconnect("Gnip Connection Closed") }
    end

    def consume(&block)
      @stream.on_message(&block)
      @stream.connect
    end
  end
end
