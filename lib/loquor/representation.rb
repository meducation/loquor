module Loquor
  class RepresentationHashKeyMissingError < LoquorError

  end
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
      fetch_indescriminately(key)
    rescue RepresentationHashKeyMissingError
      nil
    end

    def method_missing(name, *args)
      fetch_indescriminately(name, *args)
    rescue RepresentationHashKeyMissingError
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
        raise RepresentationHashKeyMissingError.new
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
