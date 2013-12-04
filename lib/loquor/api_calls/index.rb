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
        if value.is_a?(String)
          query_string << "#{key}=#{URI.encode(value)}"
        elsif value.is_a?(Array)
          value.each do |v|
            query_string << "#{key}[]=#{URI.encode(v)}"
          end
        else
          raise LoquorError.new("Filter values must be strings or arrays.")
        end
      end
      "#{klass.path}?#{query_string.join("&")}"
    end
  end
end
