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
      assert_raises(NameError) do
        foobar.description = "Cat"
      end
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
  end
end

