module Loquor
  class HttpAction::Test < Minitest::Test
    def setup 
      super 
      @access_id = "123"
      @secret_key = "Foobar132"
      @endpoint = "http://www.thefoobar.com"
      @cache = mock()
    end

    def deps
      logger = mock()
      logger.stubs(info: nil)
      logger.stubs(error: nil)

      config = mock()
      config.stubs(logger: logger)
      config.stubs(access_id: @access_id)
      config.stubs(secret_key: @secret_key)
      config.stubs(endpoint: @endpoint)
      config.stubs(cache: @cache)
      config.stubs(retry_backoff: 2)
      config.stubs(max_retries: 5)
      config.stubs(retry_503s: true)
      {config: config}
    end
    
    def test_execute_signs_and_executes
      json = "{}"
      action = HttpAction.new("", deps)
      action.expects(signed_request: mock(execute: json))
      assert_equal json, action.send(:execute)
    end

    def test_execute_retries_on_503
      json = "{}"

      r = mock()
      r.stubs(:execute).raises(RestClient::ServiceUnavailable.new)
        .then.raises(RestClient::ServiceUnavailable.new).then.returns(json)

      action = HttpAction.new("", deps)
      action.expects(signed_request: r).times(3)
      action.expects(:back_off).with(2)
      action.expects(:back_off).with(4)

      assert_equal json, action.send(:execute)
    end

    def test_disable_503_retries
      my_deps = deps
      my_deps[:config].stubs(retry_503s: false)

      r = mock()
      r.stubs(:execute).raises(RestClient::ServiceUnavailable.new)

      action = HttpAction.new("", my_deps)
      action.expects(signed_request: r)

      assert_raises RestClient::ServiceUnavailable do
        action.send(:execute)
      end
    end

    def test_execute_rethrows_503_when_retry_count_exceeded
      r = mock()
      r.stubs(:execute).raises(RestClient::ServiceUnavailable.new).times(5)

      action = HttpAction.new("", deps)
      action.expects(signed_request: r).times(5)
      action.expects(:back_off).with(2)
      action.expects(:back_off).with(4)
      action.expects(:back_off).with(8)
      action.expects(:back_off).with(16)

      assert_raises RestClient::ServiceUnavailable do
        action.send(:execute)
      end
    end

    def test_execute_rethrows_503_with_configurable_backoff_and_max_retries
      my_deps = deps
      my_deps[:config].stubs(retry_backoff: 3)
      my_deps[:config].stubs(max_retries: 4)

      r = mock()
      r.stubs(:execute).raises(RestClient::ServiceUnavailable.new).times(4)

      action = HttpAction.new("", my_deps)
      action.expects(signed_request: r).times(4)
      action.expects(:back_off).with(3)
      action.expects(:back_off).with(9)
      action.expects(:back_off).with(27)

      assert_raises RestClient::ServiceUnavailable do
        action.send(:execute)
      end
    end

    def test_execute_rethrows_404
      err = RestClient::ResourceNotFound.new

      r = mock()
      r.stubs(:execute).raises(err)

      action = HttpAction.new("", deps)
      action.expects(signed_request: r)

      assert_raises RestClient::ResourceNotFound do
        action.send(:execute)
      end
    end

    def test_user_agent
      action = HttpAction.new("", deps)
      assert /Loquor-\d+.\d+.\d+\/123/.match(action.send(:user_agent))
    end
  end
end
