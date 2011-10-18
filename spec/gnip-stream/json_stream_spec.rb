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

  describe "before_connect" do
    let(:pre_connection_block) { proc{ puts "hello world" } }

    it "calls the block passed to before_connect prior to connecting to the source" do
      subject.before_connect(&pre_connection_block)
      pre_connection_block.should_receive(:call)
      subject.connect
    end
    
  end
end
