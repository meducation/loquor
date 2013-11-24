module Loquor
  class ApiCall::Show < ApiCall

    def initialize(klass, id)
      super(klass)
      @id = id
    end

    def execute
      obj = Loquor.get("#{klass.path}/#{@id}")
      @klass.new(obj)
    end
  end
end
