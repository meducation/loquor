require File.expand_path('../test_helper', __FILE__)

module Loquor
  class GetsTest < Minitest::Test
    def test_get_should_call_new
      url = "foobar"
      deps = {x: true}
      Gets.expects(:new).with(url, deps).returns(mock(get: nil))
      Gets.get(url, deps)
    end

    def test_get_should_call_get
      Gets.any_instance.expects(:get)
      Gets.get("foobar", {})
    end

    def test_get_parses_request
      output = {'foo' => 'bar'}
      json = output.to_json
      gets = Gets.new("", {})
      gets.expects(signed_request: mock(execute: json))
      assert_equal output, gets.get
    end

    def test_request_is_generated_correctly
      url = "/foobar"
      endpoint = "http://thefoobar.com"
      config = mock(endpoint: endpoint)
      full_url = "#{endpoint}#{url}"
      deps = {config: config}

      RestClient::Request.expects(:new).with(url: full_url, method: :get)
      Gets.new(url, deps).send(:request)
    end

    def test_request_is_signed_correctly
      access_id = "foobar1"
      secret_key = "foobar2"
      config = mock(access_id: access_id, secret_key: secret_key)
      deps = {config: config}

      gets = Gets.new("", deps)
      request = RestClient::Request.new(url: "http://localhost:3000", method: :get)
      gets.expects(request: request)
      ApiAuth.expects(:sign!).with(request, access_id, secret_key)
      gets.send(:signed_request)
    end
  end
end
