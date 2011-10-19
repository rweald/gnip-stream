require 'spec_helper'
require 'gnip-stream/powertrack_authentication'

describe GnipStream::PowertrackAuthentication do
  subject { GnipStream::PowertrackAuthentication.new("http://example.com", 
                                                     "user", "password") }
  describe "#authenticate" do
    let(:fake_request) { double("fake request") }
    it "should make a request to the GNIP API to receive access cookie" do
      EM::HttpRequest.should_receive(:new).with("http://example.com").and_return(fake_request)
      fake_request.should_receive(:get) do |args|
        args[:head].should == {'authorization' => ["user", "password"]}
        double.as_null_object
      end
                                             
      subject.authenticate
    end   
  end

  describe "#parse_response_header" do
    it "should set the stream url based on 'LOCATION' header" do
      subject.parse_response_header({"SET_COOKIE" => "session_token=foobar; domain=.gnip.com; path=/;
          expires=Wed, 13-Jul-2011 22:10:10 GMT _base_session=hello; path=/; HttpOnly"})
      subject.cookies.should == "session_token=foobar; domain=.gnip.com; path=/"
    end

    it "should set the url that we can stream data from" do
      subject.parse_response_header("LOCATION" => "http://example.com", "SET_COOKIE" => "")
      subject.location.should == "http://example.com"
    end
  end
end
