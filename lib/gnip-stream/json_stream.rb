require 'gnip-stream/stream_delegate'

module GnipStream
  class JsonStream
    include StreamDelegate
    def initialize(url, headers={})
      json_processor = JsonDataBuffer.new("\r\n", /^\{.*\}\r\n/)
      @stream = Stream.new(url, json_processor, headers)
    end
  end
end
