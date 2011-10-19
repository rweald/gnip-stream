require 'spec_helper'
require 'gnip-stream/error_reconnect'

require 'spec_helper'

describe GnipStream::ErrorReconnect do
  let(:fake_stream) { double("fake stream that causes errors") }
  subject { GnipStream::ErrorReconnect.new(fake_stream, :connect, "Failed to reconnect") }
  before { subject.stub(:sleep) }
  describe "#attempt_to_reconnect" do
    it "should call the specified method on the class generating the error if reconnect count is less than 5" do
      fake_stream.should_receive(:connect)
      subject.attempt_to_reconnect
    end

    it "should raise an error with the specified error_message if reconnect fails maximum number of times" do
      subject.instance_variable_set(:@reconnect_attempts, 6)
      lambda { subject.attempt_to_reconnect}.should raise_error(/reconnect/)
    end

  end
end

