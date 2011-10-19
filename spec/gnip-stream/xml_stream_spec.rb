require 'spec_helper'
require 'gnip-stream/xml_stream'

describe GnipStream::XmlStream do
  subject { GnipStream::XmlStream.new("http://example.com") }
  describe "#initialize" do
    it "creates underlying stream object with a json specific data buffer" do
      GnipStream::Stream.should_receive(:new) do |url, processor, headers|
        url.should == "http://example.com"
      end
      GnipStream::XmlStream.new("http://example.com")
    end
  end

  describe "#method_missing" do
    let(:underlying_stream) { double("GnipStream::Stream") }
    before do
      GnipStream::Stream.stub(:new => underlying_stream)
    end

    it "delegates all available methods to the underlying stream class" do
      underlying_stream.should_receive(:connect)
      subject.connect
    end

    it "raises a method not found error on self if underlying stream can not respond to the method" do
      lambda { subject.foobar }.should raise_error(NoMethodError)
    end
  end
end
