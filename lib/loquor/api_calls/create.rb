module Loquor
  class ApiCall::Create < ApiCall

    def initialize(path, payload)
      super(path)
      @payload = payload
    end

    def execute
      Loquor.post(@path, @payload)
    end
  end
end

