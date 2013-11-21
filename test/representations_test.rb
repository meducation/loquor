require File.expand_path('../test_helper', __FILE__)

module Loquor
  class RepresentationTest < Minitest::Test

    {
      MediaFile: "/media_files",
      User: "/users"
      GroupDiscussion: "/group_discussions"
      GroupDiscussionPost: "/group_discussion_posts"
    }.each do |klass, path|
      define_method "test_#{klass}_set_up_correctly" do
        assert Loquor.const_defined?(klass)
      end

      define_method "test_#{klass}_stores_path_up_correctly" do
        assert_equal path, Loquor.const_get(klass).path
      end
    end
  end
end

