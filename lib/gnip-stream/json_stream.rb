require 'gnip-stream/stream_delegate'

module GnipStream
  class JsonStream
    include StreamDelegate
    def initialize(url, headers={})
      json_processor = DataBuffer.new(Regexp.new(/^(\{.*\})\s\s(.*)/))
      @_stream = Stream.new(url, json_processor, headers)
    end
  end
end
