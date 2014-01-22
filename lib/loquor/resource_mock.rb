module Loquor
  module ResourceMock

    def self.extended(x)
      x.class_eval do
        def method_missing(name, *args)
          if name[-1] == "="
            if self.class.attributes.keys.map{ |k| :"#{k}=" }.include?(name)
              attr = name.to_s[0..-2].to_sym
              @data[attr] = args[0]
            else
              raise NameError.new("undefined local variable or method '#{name}' for #{self.class.name}")
            end
          else
            super(name, *args)
          end
        end
      end
    end

    def attributes
      @attributes
    end

    def attributes=(attrs)
      @attributes = attrs
    end

    def sample(overrides = {})
      arbitary_attributes = (overrides.keys - attributes.keys)
      unless arbitary_attributes.empty?
        raise NameError.new("undefined local variable or method '#{arbitary_attributes.first}' for #{self.name}")
      end
      self.new(attributes.merge(overrides))
    end

    def find(id)
      self.new(attributes.merge(id: id))
    end

    def where(*args)
      [ find(1), find(2) ]
    end

    def create(*attrs)
      self.new(*attrs)
    end

    def update(*attrs)
      true
    end
  end
end
