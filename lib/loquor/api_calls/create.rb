module Loquor
  class ApiCall::Create < ApiCall

    def initialize(klass, payload)
      super(klass)
      @payload = payload
    end

    def execute
      klass.new Loquor.post(klass.path, @payload)
    end
  end
end

