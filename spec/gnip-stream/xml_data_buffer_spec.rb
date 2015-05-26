require 'spec_helper'
require 'gnip-stream/xml_data_buffer'

describe GnipStream::XmlDataBuffer do
  subject { GnipStream::XmlDataBuffer.new(/(test)(.*)/) }
  describe "#initialize" do
    it "accepts a regex pattern that will be used to match complete entries" do
      pattern = Regexp.new(/hello/)
      GnipStream::XmlDataBuffer.new(pattern).pattern.should == pattern
    end
  end

  describe "#process" do
    it "appends the data to the buffer" do
      subject.process("hello")
      subject.instance_variable_get(:@buffer).should == "hello"
    end
  end

  describe "#complete_entries" do
    it "returns a list of complete entries" do
      subject.process("test")
      subject.complete_entries.should == ["test"]
    end
  end
end
