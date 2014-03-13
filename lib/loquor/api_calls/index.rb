module Loquor
  class ApiCall::Index < ApiCall

    attr_reader :criteria, :clauses

    def initialize(klass)
      super(klass)
      @criteria = {}
      @clauses = []
    end

    def where(data)
      case data
      when String
        @clauses << data
      else
        data.each do |key, value|
          @criteria[key] = value
        end
      end
      self
    end

    def select(value)
      @criteria[:fields] ||= []
      @criteria[:fields] += value
      self
    end

    def order(value)
      @order = value
      self
    end

    def per(value)
      @per = value
      self
    end
    alias_method :limit, :per

    def page(value)
      @page = value
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
      @clauses.each do |clause|
        add_clause(query_string, clause)
      end

      query_string << "per=#{@per}" if @per
      query_string << "page=#{@page}" if @page
      query_string << "order=#{@order}" if @order

      "#{klass.path}?#{query_string.join("&")}"
    end

    def add_criteria(query_string, key, value)
      substitute_value = Loquor.config.substitute_values[value]
      if !substitute_value.nil?
        query_string << "#{key}=#{URI.encode(substitute_value)}"
      else
        case value
        when String, Symbol, Numeric, Date, Time, DateTime
          query_string << "#{key}=#{URI.encode(value.to_s)}"
        when Array
          value.each do |v|
            query_string << "#{key}[]=#{URI.encode(v.to_s)}"
          end
        when Hash
          value.each do |k,v|
            query_string << "#{key}[#{k}]=#{URI.encode(v.to_s)}"
          end
        else
          raise LoquorError.new("Filter values must be strings, arrays, date, time, datetime or single-depth hashes.")
        end
      end
    end

    def add_clause(query_string, clause)
      query_string << "clauses[]=#{URI.encode(clause.to_s)}"
    end
  end
end
