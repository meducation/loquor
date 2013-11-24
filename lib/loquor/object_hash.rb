module Loquor
  class ObjectHashKeyMissingError < LoquorError
  end

  class ObjectHash
    def initialize(hash)
      @hash = hash
    end

    def ==(other)
      if other.is_a?(ObjectHash)
        @hash == other.get_instance_variable(:@hash)
      elsif other.is_a?(Hash)
        @hash == other
      else
        false
      end
    end

    def [](key)
      fetch_indescriminately(key)
    rescue ObjectHashKeyMissingError
      nil
    end

    def method_missing(name, *args)
      fetch_indescriminately(name, *args)
    rescue ObjectHashKeyMissingError
      @hash.send(name, *args)
    end

    private

    def fetch_indescriminately(name, *args)
      if @hash.has_key?(name)
        @hash[name]
      elsif @hash.has_key?(name.to_s)
        @hash[name.to_s]
      elsif @hash.has_key?(name.to_s.to_sym)
        @hash[name.to_s.to_sym]
      else
        raise ObjectHashKeyMissingError.new
      end
    end
  end
end

class Hash
  alias_method :hash_equals, :==
  def ==(other)
    if other.is_a?(Loquor::ObjectHash)
      other == self
    else
      hash_equals(other)
    end
  end
end
