require 'spec_helper'
require 'gnip-stream/powertrack_client'

describe GnipStream::PowertrackClient do
  let(:fake_stream) { double("GnipStream::JsonStream").as_null_object }
  let(:fake_auth) { double("GnipStream::PowertrackAuthentication").as_null_object }
  before do
    GnipStream::JsonStream.stub(:new => fake_stream)
    GnipStream::PowertrackAuthentication.stub(:new => fake_auth) 
  end

  subject { GnipStream::PowertrackClient.new("http://example.com", "user", "password") }

  describe "#initialize" do
    it "initializes a PowertrackAuthentication instance" do
      GnipStream::PowertrackAuthentication.should_receive(:new)
      subject
    end

    it "initializes an instance JsonStream" do
      GnipStream::JsonStream.should_receive(:new) 
      subject
    end
  end

  describe "configure_handlers" do
    it "sets up the appropriate error and close handlers" do
      fake_stream.should_receive(:on_error).twice    
      fake_stream.should_receive(:on_connection_close).twice
      subject.configure_handlers
    end
  end

  describe "#authenticate" do
    it "performs the necessary authentication and passes appropriate credentials to stream" do
      fake_auth.should_receive(:authenticate)
      fake_auth.should_receive(:location).and_return("http://example.com")
      fake_auth.should_receive(:cookies).and_return("some cookie")

      fake_stream.should_receive(:url=).with("http://example.com") 
      fake_stream.should_receive(:headers=)
      subject.authenticate
    end
  end

  describe "#consume" do
    it "setup the client callback" do
      fake_stream.should_receive(:on_message)
      subject.consume
    end

    it "connects to the stream" do
      fake_stream.should_receive(:connect)
      subject.consume
    end
  end
end
