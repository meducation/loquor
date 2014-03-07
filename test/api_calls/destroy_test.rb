require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class ApiCall::DestroyTest < Minitest::Test
    def test_delete_is_called_correctly
      klass = mock
      klass.stubs(new: nil)
      klass.stubs(path: "/foobar")
      id = 5
      Loquor.expects(:delete).with("#{klass.path}/#{id}")
      ApiCall::Destroy.new(klass, id).execute
    end
  end
end

