require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ResourceTest < Minitest::Test
    class Foobar < Resource
      self.path = "/foobar"
    end

    def test_find_should_get_correct_path_with_simple_path
      id = 8
      Loquor.expects(:get).with("/foobar/#{id}")
      Foobar.find(id)
    end

    def test_find_each_should_get_correct_path
      Loquor.expects(:get).with("/foobar?&page=1&per=200").returns([])
      Foobar.find_each
    end

    def test_find_each_should_yield_block
      Loquor.expects(:get).returns([{id: 1}])
      ids = []
      Foobar.find_each do |json|
        ids << json['id']
      end
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

    def test_update_should_put_correct_params
      id = 8
      payload = {bar: 'foo'}
      Loquor.expects(:put).with("/foobar/#{id}", payload: payload)
      Foobar.update(id, payload)
    end
   
    def test_can_read_path
      assert_equal "/foobar", Foobar.path
    end
    
    def test_cache_flag_false_by_default
      refute Foobar.cache
    end
  end
end
