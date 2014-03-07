module Loquor
  class ApiCall
    attr_reader :klass
    def initialize(klass)
      @klass = klass
    end
  end
end

require 'loquor/api_calls/create'
require 'loquor/api_calls/update'
require 'loquor/api_calls/show'
require 'loquor/api_calls/index'
require 'loquor/api_calls/destroy'
