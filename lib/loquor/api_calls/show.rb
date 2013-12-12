module Loquor
  class ApiCall::Show < ApiCall

    def initialize(klass, id)
      super(klass)
      @id = id
    end

    def execute
      obj = if (klass.cache)
        Loquor.get("#{klass.path}/#{@id}", cache=klass.cache)
      else
        Loquor.get("#{klass.path}/#{@id}")
      end
      @klass.new(obj)
    end
  end
end
