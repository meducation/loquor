require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class ApiCall::UpdateTest < Minitest::Test
    def test_put_is_called_correctly
      klass = mock
      klass.stubs(new: nil)
      klass.stubs(path: "/foobar")
      id = 5
      payload = {foo: 'bar'}
      Loquor.expects(:put).with("#{klass.path}/#{id}", payload)
      update = ApiCall::Update.new(klass, id, payload).execute
    end
  end
end

