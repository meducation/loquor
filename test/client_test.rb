require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ClientTest < Minitest::Test
    def test_initialize_should_create_config
      Configuration.expects(:new)
      Client.new
    end

    def test_get_calls_gets
      url = "foobar"

      client = Client.new
      deps = {config: client.config}
      Gets.expects(:get).with(url, deps)
      client.get(url)
    end

    def test_post_calls_posts
      url = "foobar"
      payload = {x: true}

      client = Client.new
      deps = {config: client.config}
      Posts.expects(:post).with(url, payload, deps)
      client.post(url, payload)
    end
  end
end
