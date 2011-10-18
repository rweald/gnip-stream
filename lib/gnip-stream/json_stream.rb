module GnipStream
  class JsonStream

    DEFAULT_OPTIONS = {
      :timeout => 0
    }

    attr_accessor :headers, :options, :url, :username, :password

    def initialize(args)
      @headers = args[:headers] || {}
      @options = DEFAULT_OPTIONS.merge(args[:options] || {})
      @url = args[:url]
      @username = args[:username]
      @password = args[:password]
    end

       
  end
end
