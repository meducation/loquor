require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class ApiCall::ShowTest < Minitest::Test

    def test_response_is_a_representation
      show = ApiCall::Show.new("", 1)
      Loquor.stubs(get: {foo: 'bar'}.to_json)
      response = show.execute
      assert response.is_a?(Representation)
    end
  end
end
