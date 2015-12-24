require 'spec_helper'
require 'gnip-stream/json_data_buffer'

describe GnipStream::JsonDataBuffer do
  subject { GnipStream::JsonDataBuffer.new(/^.*\r\n/) }
  describe "#initialize" do
    it "accepts a regex pattern that will be used to match complete entries" do
      split_pattern = "\n"
      GnipStream::JsonDataBuffer.new(split_pattern).split_pattern.should == split_pattern
    end
  end

  describe "#process" do
    it "appends the data to the buffer" do
      subject.process("hello\r\nother")
      subject.instance_variable_get(:@buffer).should == "hello\r\nother"
    end
  end

  describe "#complete_entries" do
    it "returns a list of complete entries" do
      subject.process("hello\r\nother")
      subject.complete_entries.should == ["hello"]
      subject.instance_variable_get(:@buffer).should == "other"
    end
  end

  describe "#multiple complete_entries" do
    it "returns a list of complete entries" do
      subject.process("hello\r\nhello2\r\nhello3\r\nhel")
      subject.complete_entries.should == ["hello","hello2","hello3"]
      subject.instance_variable_get(:@buffer).should == "hel"
    end
  end
end
