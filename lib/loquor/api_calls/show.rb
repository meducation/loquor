module Loquor
  class ApiCall::Show < ApiCall

    def initialize(path, id)
      super(path)
      @id = id
    end

    def execute
      Loquor.get("#{@path}/#{@id}")
    end
  end
end
