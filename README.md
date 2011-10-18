# gnip-stream

gnip-stream is a ruby library to connect and stream data from [GNIP](http://gnip.com/).
It utilizes EventMachine and threads under the hood to provide a true streaming
experience without you having to worry about writing non blocking code.

##Installation

Installing gnip-stream is easy. Simply add the following line to your
```Gemfile```:

```ruby
gem 'gnip-stream'
```

##Simple Usage

```ruby
require 'gnip-stream'

twitter_stream = GnipStream::Powertrack.new(:url => "http://yourstreamingurl.gnip.com", 
                                            :username => "someuser", :password => "password")
twitter_stream.on_message do |message|
  #process the message however you want
  puts message
end
```