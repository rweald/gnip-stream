module GnipStream
  class ErrorReconnect
    def initialize(source_class, method_name, error_message)
      @source_class = source_class
      @method_name = method_name
      @error_message = error_message
      @reconnect_attempts = 0
    end

    def attempt_to_reconnect
      if @reconnect_attempts < 5
        sleep(2)
        @source_class.send(@method_name)
      else
        reconnect_failed_raise_error
      end
    end

    def reconnect_failed_raise_error
      raise @error_message
    end

  end
end
