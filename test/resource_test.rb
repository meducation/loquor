require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ResourceTest < Minitest::Test
    class Foobar < Resource
      self.path = "/foobar"
    end

    def test_respond_to_still_proxies_to_super
      foobar = Foobar.new({})
      assert_equal true, foobar.respond_to?(:to_s)
    end

    def test_respond_to_still_returns_false_for_non_existant_keys
      foobar = Foobar.new({})
      assert_equal false, foobar.respond_to?(:dog)
    end

    def test_respond_to_should_proxy_to_data
      foobar = Foobar.new({foo: 'bar'})
      assert foobar.respond_to?(:foo)
    end

    def test_find_should_get_correct_path_with_simple_path
      id = 8
      Loquor.expects(:get).with("/foobar/#{id}", {cache: nil})
      Foobar.find(id)
    end

    def test_find_each_should_get_correct_path
      Loquor.expects(:get).with("/foobar?&page=1&per=200").returns([])
      Foobar.find_each
    end

    def test_find_each_should_yield_block
      Loquor.expects(:get).returns([{id: 1}])
      count = 0
      Foobar.find_each do |json|
        count += 1
      end
      assert_equal 1, count
    end

    def test_select_should_proxy
      args = {a: 'b'}
      Loquor::ApiCall::Index.any_instance.expects(:select).with(args)
      Foobar.select(args)
    end

    def test_where_should_get_correct_path_with_simple_path
      email = "foobar"
      Loquor.expects(:get).with("/foobar?email=#{email}").returns([])
      Foobar.where(email: email).to_a
    end

    def test_create_should_put_correct_params
      payload = {bar: 'foo'}
      Loquor.expects(:post).with("/foobar", payload: payload)
      Foobar.create(payload)
    end

    def test_update_should_put_correct_params
      id = 8
      payload = {bar: 'foo'}
      Loquor.expects(:put).with("/foobar/#{id}", payload: payload)
      Foobar.update(id, payload)
    end

    def test_destroy_should_delete
      id = 8
      Loquor.expects(:delete).with("/foobar/#{id}")
      Foobar.destroy(id)
    end

    def test_can_read_path
      assert_equal "/foobar", Foobar.path
    end

    def test_cache_flag_false_by_default
      refute Foobar.cache
    end

    def test_raises_on_missing_attribute
      representation = Foobar.new({})
      ex = assert_raises(NameError) do
        representation.random_attr
      end
      assert_equal "undefined local variable or method 'random_attr' for Loquor::ResourceTest::Foobar", ex.message
    end
  end
end
