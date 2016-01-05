module GnipStream
  class ErrorReconnect
    def initialize(source_class, method_name)
      @source_class = source_class
      @method_name = method_name
      @reconnect_attempts = 0
    end

    def attempt_to_reconnect(error_message)
      puts error_message
      @error_message = error_message
      if @reconnect_attempts < 5
        puts "Reconnecting..."
        @reconnect_attempts +=1
        sleep(2)
        @source_class.send(@method_name)
      else
        puts "Reconnecting failed."
        reconnect_failed_raise_error
      end
    end

    def reconnect_failed_raise_error
      raise @error_message
    end

  end
end
