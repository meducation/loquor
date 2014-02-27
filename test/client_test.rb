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
      HttpAction::Get.expects(:get).with(url, deps)
      client.get(url)
    end

    def test_put_calls_puts
      url = "foobar"
      payload = {foo: 'bar'}

      client = Client.new
      deps = {config: client.config}
      HttpAction::Put.expects(:put).with(url, payload, deps)
      client.put(url, payload)
    end

    def test_post_calls_posts
      url = "foobar"
      payload = {x: true}

      client = Client.new
      deps = {config: client.config}
      HttpAction::Post.expects(:post).with(url, payload, deps)
      client.post(url, payload)
    end


    def test_get_calls_gets_with_cache_flag
      url = "foobar"

      client = Client.new
      deps = {config: client.config, should_cache: true}
      HttpAction::Get.expects(:get).with(url, deps)
      client.get(url, cache: true)
    end
  end
end
