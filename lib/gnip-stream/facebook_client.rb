module GnipStream
  class FacebookClient
    def initialize(url, username, password)
      @stream = XmlStream.new(url, "authorization" => [username, password])
      configure_handlers
    end

    def configure_handlers
      @stream.on_error { |error| raise "Gnip Connection Error. Reason was: #{error}" }
      @stream.on_connection_close { raise "Gnip Connection Closed" }
    end

    def consume(&block)
      @stream.on_message(&block)
      @stream.connect
    end
  end
end
