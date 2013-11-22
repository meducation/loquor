require File.expand_path('../test_helper', __FILE__)

module Loquor
  class RepresenationTest < Minitest::Test
    def test_is_accessible_as_a_hash
      representation = Representation.new({foo: "bar"})
      assert_equal "bar", representation[:foo]
    end

    def test_hash_keys_are_accessible_via_methods
      representation = Representation.new({foo: "bar"})
      assert_equal "bar", representation.foo
    end
  end
end
