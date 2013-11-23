require File.expand_path('../test_helper', __FILE__)

module Loquor
  class RepresenationTest < Minitest::Test
    def test_is_accessible_as_a_hash
      representation = Representation.new({foo: "bar"})
      assert_equal "bar", representation[:foo]
    end

    def test_hash_symbol_keys_are_accessible_as_strings
      representation = Representation.new({foo: "bar"})
      assert_equal "bar", representation["foo"]
    end

    def test_hash_string_keys_are_accessible_as_symbols
      representation = Representation.new({"foo" => "bar"})
      assert_equal "bar", representation[:foo]
    end

    def test_hash_keys_are_accessible_as_orignals
      representation = Representation.new({1 => "bar"})
      assert_equal "bar", representation[1]
    end

    def test_hash_keys_are_accessible_via_methods
      representation = Representation.new({foo: "bar"})
      assert_equal "bar", representation.foo
    end
  end
end
