module Loquor
  class ApiCall::Update < ApiCall

    def initialize(klass, id, payload)
      super(klass)
      @id = id
      @payload = payload
    end

    def execute
      klass.new Loquor.put("#{klass.path}/#{@id}", @payload)
    end
  end
end
