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

      config = mock()
      config.stubs(logger: logger)
      config.stubs(access_id: @access_id)
      config.stubs(secret_key: @secret_key)
      config.stubs(endpoint: @endpoint)
      config.stubs(cache: @cache)
      {config: config}
    end
    
    def test_execute_signs_and_executes
      json = "{}"
      action = HttpAction.new("", deps)
      action.expects(signed_request: mock(execute: json))
      assert_equal json, action.send(:execute)
    end
  end
end
