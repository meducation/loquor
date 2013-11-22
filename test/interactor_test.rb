require File.expand_path('../test_helper', __FILE__)

module Loquor
  class InteractorTest < Minitest::Test
    class FoobarInteractor
      extend Interactor::ClassMethods
      include Interactor::InstanceMethods

      def self.path
        "/foobar"
      end
    end

    def test_find_should_get_correct_path_with_simple_path
      id = 8
      Loquor.expects(:get).with("/foobar/#{id}")
      FoobarInteractor.find(id)
    end

    def test_find_each_should_get_correct_path
      Loquor.expects(:get).with("/foobar?&page=1&per=200").returns([])
      FoobarInteractor.find_each
    end

    def test_find_each_should_yield_block
      Loquor.expects(:get).returns([{id: 1}])
      ids = []
      FoobarInteractor.find_each do |json|
        ids << json['id']
      end
    end

    def test_where_should_get_correct_path_with_simple_path
      email = "foobar"
      Loquor.expects(:get).with("/foobar?email=#{email}").returns([])
      FoobarInteractor.where(email: email).to_a
    end
  end
end
