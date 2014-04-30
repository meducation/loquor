require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ResourceMockTest < Minitest::Test
    class Foobar < Resource
      extend ResourceMock
      self.attributes = {
        name: "Foobar"
      }
    end

    def test_should_be_able_to_set_allowed_attributes
      name = "Cat"
      foobar = Foobar.find(1)
      foobar.name = name
      assert_equal name, foobar.name
    end

    def test_should_not_be_able_to_set_arbitary_attributes
      foobar = Foobar.find(1)
      ex = assert_raises(NameError) do
        foobar.description = "Cat"
      end
      assert_equal "undefined local variable or method 'description=' for Loquor::ResourceMockTest::Foobar", ex.message
    end

    def test_should_return_sample_object
      foobar = Foobar.sample
      assert_equal "Foobar", foobar.name
    end

    def test_should_allow_sample_attributes_to_be_overriden
      name = "Cat"
      foobar = Foobar.sample(name: name)
      assert_equal name, foobar.name
    end

    def test_should_not_be_able_to_override_arbitary_attributes
      ex = assert_raises(NameError) do
        Foobar.sample(cat: "foobar")
      end
      assert_equal "undefined local variable or method 'cat' for Loquor::ResourceMockTest::Foobar", ex.message
    end

    def test_should_allow_any_attributes_for_custom_sample
      foobar = Foobar.custom_sample(foo: 'bar')
      assert_equal "bar", foobar.foo
    end

    def test_should_respond_to_create
      name = "foobar123"
      foobar = Foobar.create(name: name)
      assert_equal name, foobar.name
    end

    def test_should_respond_to_update
      assert_equal true, Foobar.update(1, name: "foobar")
    end
  end
end

