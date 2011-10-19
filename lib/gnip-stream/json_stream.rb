module GnipStream
  class JsonStream
    def initialize(url, headers={})
      json_processor = DataBuffer.new(Regexp.new(/^(\{.*\})\s\s(.*)/))
      @_stream = Stream.new(url, json_processor, headers)
    end

    #Magic Method that will delegate all 
    # method calls to underlying stream if possible
    def method_missing(m, *args, &block)
      if @_stream.respond_to?(m)
        @_stream.send(m, *args, &block)
      else
        super(m, *args, &block)
      end
    end
  end
end
