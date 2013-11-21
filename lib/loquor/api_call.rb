module Loquor
  class ApiCall
    def initialize(path)
      @path = path
    end
  end
end

require 'loquor/api_calls/create'
require 'loquor/api_calls/show'
require 'loquor/api_calls/index'
