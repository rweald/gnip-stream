require 'spec_helper'
require 'gnip-stream/json_data_buffer'

describe GnipStream::JsonDataBuffer do
  subject { GnipStream::JsonDataBuffer.new("\n", /hello/) }
  describe "#initialize" do
    it "accepts a regex pattern that will be used to match complete entries" do
      split_pattern = "\n"
      check_pattern = Regexp.new(/hello/)
      GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).check_pattern.should == check_pattern
      GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).split_pattern.should == split_pattern
    end
  end

  describe "#process" do
    it "appends the data to the buffer" do
      subject.process("hello\nother")
      subject.instance_variable_get(:@buffer).should == "hello\nother"
    end
  end

  describe "#complete_entries" do
    it "returns a list of complete entries" do
      subject.process("hello\nother")
      subject.complete_entries.should == ["hello"]
      subject.instance_variable_get(:@buffer).should == "other"
    end
  end
end
