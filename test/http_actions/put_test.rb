require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class HttpAction::PutTest < HttpAction::Test
    def test_put_should_call_new
      url = "foobar"
      payload = {y: false}
      deps = {x: true}
      HttpAction::Put.expects(:new).with(url, payload, deps).returns(mock(put: nil))
      HttpAction::Put.put(url, payload, deps)
    end

    def test_put_should_call_put
      HttpAction::Put.any_instance.expects(:put)
      HttpAction::Put.put("foobar", {}, {})
    end

    def test_put_parses_request
      output = {'foo' => 'bar'}
      json = output.to_json
      puts = HttpAction::Put.new("", {}, deps)
      puts.expects(signed_request: mock(execute: json))
      assert_equal 'bar', puts.put.foo
    end

    def test_request_is_generated_correctly
      url = "/foobar"
      payload = {foo: true, bar: false}
      full_url = "#{@endpoint}#{url}"

      RestClient::Request.expects(:new).with(
        url: full_url,
        accept: :json,
        payload: payload.to_json,
        headers: {'Content-type' => 'application/json'},
        method: :put
      )
      HttpAction::Put.new(url, payload, deps).send(:request)
    end

    def test_request_is_signed_correctly
      puts = HttpAction::Put.new("", {}, deps)
      request = RestClient::Request.new(url: "http://localhost:3000", method: :put)
      puts.expects(request: request)
      ApiAuth.expects(:sign!).with(request, @access_id, @secret_key)
      puts.send(:signed_request)
    end

    def test_response_is_a_representation
      puts = HttpAction::Put.new("", {}, deps)
      puts.stubs(signed_request: mock(execute: {foo: 'bar'}.to_json))
      response = puts.put
      assert response.is_a?(Resource)
    end
  end
end


