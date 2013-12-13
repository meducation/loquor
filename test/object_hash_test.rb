require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ObjectHashTest < Minitest::Test
    def test_is_accessible_as_a_hash
      representation = ObjectHash.new({foo: "bar"})
      assert_equal "bar", representation[:foo]
    end

    def test_hash_symbol_keys_are_accessible_as_strings
      representation = ObjectHash.new({foo: "bar"})
      assert_equal "bar", representation["foo"]
    end

    def test_hash_string_keys_are_accessible_as_symbols
      representation = ObjectHash.new({"foo" => "bar"})
      assert_equal "bar", representation[:foo]
    end

    def test_hash_keys_are_accessible_as_orignals
      representation = ObjectHash.new({1 => "bar"})
      assert_equal "bar", representation[1]
    end

    def test_hash_keys_are_accessible_via_methods
      representation = ObjectHash.new({foo: "bar"})
      assert_equal "bar", representation.foo
    end

    def test_non_strict_returns_nil_on_missing_attribute
      representation = ObjectHash.new({foo: "bar"})
      assert_equal nil, representation.cat
    end

    def test_strict_raises_on_missing_attribute
      representation = ObjectHash.new({foo: "bar"}, strict: true)
      ex = assert_raises(ObjectHashKeyMissingError) do
        representation.cat
      end
      assert_equal "cat", ex.message
    end
  end
end
