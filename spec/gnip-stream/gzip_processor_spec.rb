require 'spec_helper'
require 'gnip-stream/gzip_processor'

describe GnipStream::GzipProcessor do
  subject { GnipStream::GzipProcessor.new } 
  let(:fake_gzip_reader) { double("fake gzip reader").as_null_object }

  before { Zlib::GzipReader.stub(:new => fake_gzip_reader) }

  describe "#on_uncompressed_chunk=" do
    it "should store the callback that will be fired when chunk is decompressed" do
      callback = proc { "uncompressed chunk" }
      subject.on_uncompressed_chunk = callback
      subject.on_uncompressed_chunk.should == callback
    end
  end

  describe "#<<" do
    it "should delegate to the push method" do 
      subject.should_receive(:push).with("compressed chunk")
      subject << "compressed chunk"
    end
  end

  describe "#push" do
    let(:gzip_header) { "0123456789" }
    let(:rest_of_gzipped_string) { "hello world" }
    let(:compressed_line) { gzip_header + rest_of_gzipped_string }

    xit "should return the length of the chunk that it received" do
      subject.push("1").should == 1
    end

    context "the processor has not received any data yet" do
      subject { GnipStream::GzipProcessor.new }
      
      it "stores the gzip header if this is the first 10 bytes received" do
        subject.push(compressed_line)
        subject.gzip_header.should == gzip_header
      end

      it "should not buffer the gzip header" do
        subject.push(compressed_line)
        subject.buffer.should == rest_of_gzipped_string
      end
    end

    context "when the processor has already received the gzip header" do
      subject do
        GnipStream::GzipProcessor.new.tap do |gz|
          gz.instance_variable_set(:@gzip_header, "gzip header")
          gz.on_uncompressed_chunk = proc { |chunk| chunk }
        end
      end

      it "buffers content until you have 2050 characters which is the read size for the IO object backing Zlib::Gzip" do
        compressed_line = "a" * 2049
        fake_gzip_reader.should_not_receive(:readpartial)
        subject.push(compressed_line)
        subject.buffer.should == compressed_line
      end


      it "uncompresses the buffered content once we have more than 2050 characters" do
        subject.push("a" * 2050)
        fake_gzip_reader.should_receive(:readpartial).with(2051)
        subject.push("a")
      end

      it "calls the supplied 'on_uncompressed_chunk' callback with uncompressed chunk" do
        fake_gzip_reader.stub(:readpartial => "uncompressed chunk")
        callback = Proc.new { |chunk| chunk }
        subject.on_uncompressed_chunk = callback
        callback.should_receive(:call).with("uncompressed chunk")
        subject.push("a" * 2051)
      end

      it "should reset the buffer after decompressing the buffered data" do
        subject.push("a" * 2051)
        subject.buffer.should == ""
      end
    end
  end
end
