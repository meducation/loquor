module Loquor
  class ApiCall
    include Loquor::PathBuilder
    def initialize(path)
      setup_path_builder(path)
    end
  end
end

require 'loquor/api_calls/show'
require 'loquor/api_calls/index'
