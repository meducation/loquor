module Loquor
  class ApiCall::Show < ApiCall

    def initialize(path, id)
      super(path)
      @id = id
    end

    def execute
      obj = Loquor.get("#{@path}/#{@id}")
      Representation.new(obj)
    end
  end
end
