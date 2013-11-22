module Loquor
  class Representation
    def initialize(hash)
      @hash = hash
    end

    def ==(other)
      if other.is_a?(Representation)
        @hash == other.get_instance_variable(:@hash)
      elsif other.is_a?(Hash)
        @hash == other
      else
        false
      end
    end

    def [](key)
      @hash[key]
    end

    def method_missing(name, *args)
      if @hash.has_key?(name)
        @hash[name]
      else
        super
      end
    end
  end
end

class Hash
  alias_method :hash_equals, :==
  def ==(other)
    if other.is_a?(Loquor::Representation)
      other == self
    else
      hash_equals(other)
    end
  end
end
