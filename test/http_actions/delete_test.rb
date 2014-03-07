require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class HttpAction::DeleteTest < HttpAction::Test
    def test_delete_should_call_new
      url = "foobar"
      deps = {x: true}
      HttpAction::Delete.expects(:new).with(url, deps).returns(mock(delete: nil))
      HttpAction::Delete.delete(url, deps)
    end

    def test_delete_should_call_put
      HttpAction::Delete.any_instance.expects(:delete)
      HttpAction::Delete.delete("foobar", {})
    end

    def test_request_is_signed_correctly
      puts = HttpAction::Delete.new("", deps)
      request = RestClient::Request.new(url: "http://localhost:3000", method: :delete)
      puts.expects(request: request)
      ApiAuth.expects(:sign!).with(request, @access_id, @secret_key)
      puts.send(:signed_request)
    end
  end
end


