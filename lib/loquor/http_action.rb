module Loquor
  class HttpAction
    def initialize(url, deps)
      @url = url
      @config = deps[:config]
      @should_cache = deps[:should_cache]
    end

    def signed_request
      @config.logger.info "Signing request."
      ApiAuth.sign!(request, @config.access_id, @config.secret_key)
    end

    def execute
      @config.logger.info "Making HTTP request to: #{full_url}"
      signed_request.execute
    rescue RestClient::ResourceNotFound => e
      @config.logger.error("HTTP 404 when accessing #{full_url}")
      raise
    rescue => e
      @config.logger.error("Exception while executing request: #{e.message} <#{e.class}>")
      raise
    end

    private

    def full_url
      "#{@config.endpoint}#{@url}"
    end
  end
end

require 'loquor/http_actions/get'
require 'loquor/http_actions/post'
require 'loquor/http_actions/put'
