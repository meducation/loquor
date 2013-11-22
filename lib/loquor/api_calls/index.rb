module Loquor
  class ApiCall::Index < ApiCall

    attr_reader :criteria

    def initialize(path)
      super(path)
      @criteria = {}
    end

    def where(value)
      value.each do |key, value|
        @criteria[key] = value
      end
      self
    end

    # Proxy everything to the results so that this this class
    # transparently acts as an Array.
    def method_missing(name, *args, &block)
      results.send(name, *args, &block)
    end

    def find_each
      page = 1
      per = 200
      results = []
      begin
        results = Loquor.get("#{generate_url}&page=#{page}&per=#{per}")
        results.each do |result|
          yield Representation.new(result)
        end
        page += 1
      end while(results.size == per)
    end

    private

    def results
      if @results.nil?
        @results = Loquor.get(generate_url).map {|obj| Representation.new(obj)}
      end
      @results
    end

    def generate_url
      query_string = @criteria.map { |key,value|
        if value.is_a?(String)
          "#{key}=#{URI.encode(value)}"
        elsif value.is_a?(Array)
          "#{key}=[#{URI.encode(value.join(","))}]"
        else
          raise LoquorError.new("Filter values must be strings or arrays.")
        end
      }.join("&")
      "#{@path}?#{query_string}"
    end
  end
end
