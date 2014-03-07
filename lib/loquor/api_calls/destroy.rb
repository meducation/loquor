module Loquor
  class ApiCall::Destroy < ApiCall

    def initialize(klass, id)
      super(klass)
      @id = id
    end

    def execute
      klass.new Loquor.delete("#{klass.path}/#{@id}")
    end
  end
end
