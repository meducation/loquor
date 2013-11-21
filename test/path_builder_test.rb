require File.expand_path('../test_helper', __FILE__)

module Loquor
  class PathBuilderTest < Minitest::Test
    class SimplePathRepresentation
      include PathBuilder

      def initialize
        setup_path_builder("/foobar123")
      end
    end

    class ComplexPathRepresentation
      include PathBuilder

      def initialize
        setup_path_builder("/groups/:group_id/discussions")
      end
    end

    def test_find_should_get_correct_path_with_simple_path
      id = 8
      assert_equal "/foobar123", SimplePathRepresentation.new.send(:build_path)
    end

    def test_path_part_methods_are_created
      rep = ComplexPathRepresentation.new
      assert rep.respond_to?(:for_group_id)
    end

    def test_find_should_get_correct_path_with_complex_path
      group_id = 5
      rep = ComplexPathRepresentation.new
      rep.for_group_id(5)
      assert_equal "/groups/#{group_id}/discussions", rep.send(:build_path)
    end

    def test_find_should_get_raise_exception_without_path_parts
      rep = ComplexPathRepresentation.new
      assert_raises(Loquor::MissingUrlComponentError) do
        rep.send :build_path
      end
    end
  end
end

