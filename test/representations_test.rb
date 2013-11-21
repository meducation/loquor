require File.expand_path('../test_helper', __FILE__)

module Loquor
  class RepresentationTest < Minitest::Test

    {
      MediaFile: "/media_files",
      User: "/users"
    }.each do |klass, path|
      define_method "test_#{klass}_set_up_correctly" do
        assert Loquor.const_defined?(klass)
      end
    end
  end
end

