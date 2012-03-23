require 'spec_helper'
require 'gnip-stream/powertrack_client'

describe GnipStream::PowertrackClient do
  let(:fake_stream) { double("GnipStream::JsonStream").as_null_object }
  before do
    GnipStream::JsonStream.stub(:new => fake_stream)
  end

  subject { GnipStream::PowertrackClient.new("http://example.com", "user", "password") }

  describe "#initialize" do
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
