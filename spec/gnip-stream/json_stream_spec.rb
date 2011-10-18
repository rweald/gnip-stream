require 'spec_helper'
require 'gnip-stream/json_stream'

describe GnipStream::JsonStream do
  describe "#initialize" do
    it "allows you to define custom headers" do
      headers = {"keep-alive" => false}
      stream = GnipStream::JsonStream.new(:headers => headers)
      stream.headers.should == headers
    end
  end
end
