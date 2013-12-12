require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class HttpAction::GetTest < HttpAction::Test

    def test_get_should_call_new
      url = "foobar"
      deps = {x: true}
      HttpAction::Get.expects(:new).with(url, deps).returns(mock(get: nil))
      HttpAction::Get.get(url, deps)
    end

    def test_get_should_call_get
      HttpAction::Get.any_instance.expects(:get)
      HttpAction::Get.get("foobar", {})
    end

    def test_get_parses_request
      output = {'foo' => 'bar'}
      json = output.to_json

      gets = HttpAction::Get.new("", deps)
      gets.expects(signed_request: mock(execute: json))
      assert_equal output, gets.get
    end

    def test_request_is_generated_correctly
      url = "/foobar"
      full_url = "#{@endpoint}#{url}"
      RestClient::Request.expects(:new).with(url: full_url, method: :get)
      HttpAction::Get.new(url, deps).send(:request)
    end

    def test_request_is_signed_correctly
      gets = HttpAction::Get.new("", deps)
      request = RestClient::Request.new(url: "http://localhost:3000", method: :get)
      gets.expects(request: request)
      ApiAuth.expects(:sign!).with(request, @access_id, @secret_key)
      gets.send(:signed_request)
    end

    def test_get_cached_resource
      output = {'foo' => 'bar'}
      json = output.to_json

      gets = HttpAction::Get.new("", deps.merge({should_cache: true}))
      gets.expects(execute_against_cache: json)
      assert_equal output, gets.get
    end
    
    def test_cache_hit
      url = "/resource"
      full_url = "#{@endpoint}#{url}"
      cached_value = "{}"
      @cache.expects(:get).with(full_url).returns(cached_value)
      gets = HttpAction::Get.new(url, deps.merge({should_cache: true}))
      assert_equal cached_value, gets.send(:execute_against_cache)
    end

    def test_execute_http_call_on_cache_miss
      url = "/resource" 
      full_url = "#{@endpoint}#{url}"
      json_response = "{}"
      
      @cache.expects(:get).with(full_url).returns(nil)
      @cache.expects(:set).with(full_url, json_response)

      gets = HttpAction::Get.new(url, deps.merge({should_cache: true}))
      gets.expects(execute: json_response)
      assert_equal json_response, gets.send(:execute_against_cache)
    end

    def test_does_not_cache_when_no_cache_configured
      json_response = "{}"
      
      @cache = nil
      gets = HttpAction::Get.new("", deps.merge({should_cache: true}))
      gets.expects(execute: json_response)
      gets.send(:execute_against_cache)
    end
  end
end
