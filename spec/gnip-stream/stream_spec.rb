require 'spec_helper'

require 'gnip-stream/stream'

describe GnipStream::Stream do
  let(:fake_processor) { double("json processor", :process => self, 
                         :complete_entries => ["hello"])}
  subject { GnipStream::Stream.new("http://example.com", fake_processor) }

  describe "#initialize" do
    it "allows you to define custom headers" do
      headers = {"keep-alive" => false}
      stream = GnipStream::Stream.new("http://example.com", fake_processor, headers)
      stream.headers.should == headers
    end
  end

  describe "#on_message" do
    let(:on_message_block) { proc{ puts "hello world" } }
    it "accepts a block that will be called every time a message is received" do
      subject.on_message(&on_message_block)
      subject.instance_variable_get(:@on_message).should == on_message_block
    end
  end

  describe "#on_connection_close" do
    let(:on_connection_close_block) { proc{ puts "hello world" } }
    it "accepts a block that will be called every time a message is received" do
      subject.on_connection_close(&on_connection_close_block)
      subject.instance_variable_get(:@on_connection_close).should == on_connection_close_block
    end
  end

  describe "#on_error" do
    let(:on_error_block) { proc{ puts "hello world" } }
    it "accepts a block that will be called every time a message is received" do
      subject.on_error(&on_error_block)
      subject.instance_variable_get(:@on_error).should == on_error_block
    end
  end

  describe "#process_chunk" do
    let(:on_message_block) { proc{ |message| message.to_s } }
    before do
      subject.on_message(&on_message_block)
      EM.stub(:defer)
    end
    it "passes the chunk of data off to the processor object for processing" do
      fake_processor.should_receive(:process).with("hello world")
      subject.process_chunk("hello world")
    end

    it "calls the client supplied callback on a seperate thread for each message" do
      EventMachine.should_receive(:defer)
      subject.process_chunk("hello")
    end
  end

  describe "#connect" do
    let(:fake_http_request) { double("Fake HttpRequest").as_null_object }
    
    it "creates a new EM:HttpRequest get request." do
      EM::HttpRequest.should_receive(:new) do |url, _|
        url.should == "http://example.com"
        EM.stop
        fake_http_request
      end
      subject.connect
    end

    it "Does not have EM::HttpRequest automatically decompress the response." do
      EM::HttpRequest.should_receive(:new) do
        EM.stop
        fake_http_request        
      end
      fake_http_request.should_receive(:get) do |arguments|
        arguments[:decoding].should be_false
        double().as_null_object
      end
      subject.connect
    end
  end
  
end
