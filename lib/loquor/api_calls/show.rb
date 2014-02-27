module Loquor
  class ApiCall::Show < ApiCall

    def initialize(klass, id)
      super(klass)
      @id = id
    end

    def execute
      options = {cache: klass.cache}
      obj = Loquor.get("#{klass.path}/#{@id}", options)
      @klass.new(obj)
    end
  end
end
