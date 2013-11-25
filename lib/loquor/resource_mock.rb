module Loquor
  module ResourceMock

    def attributes
      @attributes
    end

    def attributes=(attrs)
      @attributes = attrs
    end

    def sample
      self.new(attributes)
    end

    def find(id)
      self.new(attributes.merge(id: id))
    end

    def where(*args)
      [ find(1), find(2) ]
    end

    def create(attrs)
      self.new(attrs)
    end
  end
end
