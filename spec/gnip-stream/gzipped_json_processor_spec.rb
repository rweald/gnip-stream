require 'spec_helper'
require 'gnip-stream/gzipped_json_processor.rb'

describe GnipStream::GzippedJSONParser do
  let(:fake_gzip_processor) { double(GnipStream::GzipProcessor).as_null_object }
  let(:fake_json_parser) { double(Yajl::Parser).as_null_object }
  before do
    GnipStream::GzipProcessor.stub(:new => fake_gzip_processor)
    Yajl::Parser.stub(:new => fake_json_parser)
  end

  describe "#initialize" do

    it "should set up callback for gzip processor" do
      fake_gzip_processor.should_receive(:on_uncompressed_chunk=)
      GnipStream::GzippedJSONParser.new
    end

    it "should set up callback for json parser" do
      fake_json_parser.should_receive(:on_parse_complete=)
      GnipStream::GzippedJSONParser.new
    end
  end
  describe "#process" do
    it "should add the chunk the GzipProcessor for decompression" do
      compressed_chunk = "compressed_chunk"
      fake_gzip_processor.should_receive(:<<).with(compressed_chunk)
      subject.process(compressed_chunk)
    end
  end

  describe "#handle_uncompressed_chunk" do
    it "should add the chunk the JSON parse buffer for parsing" do
      fake_json_parser.should_receive(:<<).with("fake json")
      subject.handle_uncompressed_chunk("fake json")
    end
  end

  describe "#handle_complete_json_entry" do
    it "should add the entry to our list of complete_entries" do
      subject.handle_complete_json_entry("json entry")
      subject.complete_entries.should == ["json entry"]
    end
  end

  describe "#complete_entries" do

    it "should return empty array if there aren't any json entries" do
      subject.complete_entries.should == []
    end

    it "should return all new complete JSON entries" do
      subject.handle_complete_json_entry("json entry")
      subject.complete_entries.should == ["json entry"]
    end

    it "should clear the previous complete_entries" do
      subject.handle_complete_json_entry("json entry")
      subject.complete_entries
      subject.complete_entries.should == []
    end
    
  end
end
