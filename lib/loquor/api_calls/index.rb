module Loquor
  class ApiCall::Index < ApiCall

    attr_reader :criteria

    def initialize(klass)
      super(klass)
      @criteria = {}
    end

    def where(value)
      value.each do |key, value|
        @criteria[key] = value
      end
      self
    end

    def select(value)
      @criteria[:fields] ||= []
      @criteria[:fields] += value
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
          yield klass.new(result)
        end
        page += 1
      end while(results.size == per)
    end

    private

    def results
      if @results.nil?
        @results = Loquor.get(generate_url).map {|obj| klass.new(obj)}
      end
      @results
    end

    def generate_url
      query_string = []
      @criteria.each do |key,value|
        add_criteria(query_string, key, value)
      end
      "#{klass.path}?#{query_string.join("&")}"
    end

    def add_criteria(query_string, key, value)
      substitute_value = Loquor.config.substitute_values[value]
      if !substitute_value.nil?
        query_string << "#{key}=#{URI.encode(substitute_value)}"
      else
        case value
        when String, Symbol, Numeric
          query_string << "#{key}=#{URI.encode(value.to_s)}"
        when Array
          value.each do |v|
            query_string << "#{key}[]=#{URI.encode(v.to_s)}"
          end
        else
          raise LoquorError.new("Filter values must be strings or arrays.")
        end
      end
    end
  end
end
