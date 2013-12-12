require File.expand_path('../test_helper', __FILE__)

module Loquor
  class LoquorTest < HttpAction::Test
    def test_get_calls_get
      url = "foo"
      Client.any_instance.expects(:get).with(url)
      Loquor.get(url)
    end
    
    def test_get_calls_get_passing_on_args
      url = "foo"
      Client.any_instance.expects(:get).with(url, cached=true)
      Loquor.get(url, cached=true)
    end

    def test_put_calls_put
      url = "foo"
      payload = "bar"
      Client.any_instance.expects(:put).with(url, payload)
      Loquor.put(url, payload)
    end

    def test_post_calls_post
      url = "foo"
      payload = "bar"
      Client.any_instance.expects(:post).with(url, payload)
      Loquor.post(url, payload)
    end
  end
end
