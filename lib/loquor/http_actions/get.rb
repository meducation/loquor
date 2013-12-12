module Loquor
  class HttpAction::Get < HttpAction
    def self.get(url, deps)
      new(url, deps).get
    end

    def initialize(url, deps)
      super
    end

    def get
      @config.logger.info "GET: #{full_url}"
      response = @should_cache ? JSON.parse(execute_against_cache) : JSON.parse(execute)
      @config.logger.info "Response: #{response}"
      response
    end
      
    def execute_against_cache
      cache = @config.cache
      if cache
        val = cache.get(request.url)
        unless val
          val = execute
          cache.set(request.url, val)
        end
        val
      else
        execute
      end 
    end

    private
    def request
      RestClient::Request.new(url: full_url, method: :get)
    end
  end
end
