# gnip-stream
[![Build Status](https://secure.travis-ci.org/rweald/gnip-stream.png)](http://travis-ci.org/rweald/gnip-stream)

gnip-stream is a ruby library to connect and stream data from [GNIP](http://gnip.com/).
It utilizes EventMachine and threads under the hood to provide a true streaming
experience without you having to worry about writing non blocking code.

##Installation

Installing gnip-stream is easy. Simply add the following line to your
```Gemfile```:

```ruby
gem 'gnip-stream', :git => "https://github.com/rweald/gnip-stream"
```

##Simple Usage

```ruby
require 'gnip-stream'

#To connect to the special twitter powertrack api
twitter_stream = GnipStream::PowertrackClient.new("http://yourstreamingurl.gnip.com", "someuser", "password")
twitter_stream.consume do |message|
  #process the message however you want
  puts message
end

#To Connect to the Facebook API
facebook_stream = GnipStream::FacebookClient.new("http://yourstreamingurl.gnip.com", "someuser", "password")
facebook_stream.consume do |message|
  puts message
end
```

##Contributors

* [Ryan Weald](https://github.com/rweald)
* [Sharethrough Team](https://github.com/sharethrough)

##License
See this code is licensed under MIT license. See [LICENSE](https://github.com/rweald/gnip-stream/blob/master/LICENSE) file for more details.

Special thanks to [Sharethrough](http://www.sharethrough.com/)
