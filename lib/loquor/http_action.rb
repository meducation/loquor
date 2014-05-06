require 'rest-client'

module Loquor
  class HttpAction
    def initialize(url, deps)
      @url = url
      @config = deps[:config]
      @should_cache = deps[:should_cache]
      @retry_count = 0
    end

    def signed_request
      req = request
      @config.logger.info "Setting user-agent."
      req.headers['User-Agent'] = user_agent
      @config.logger.info "Signing request."
      ApiAuth.sign!(req, @config.access_id, @config.secret_key)
    end

    def execute
      @config.logger.info "Making HTTP request to: #{full_url}"
      signed_request.execute
    rescue RestClient::ServiceUnavailable => e
      @config.logger.error("503 received for request to #{@url}.")
      @retry_count += 1
      if should_retry
        @config.logger.error("Retrying (retry attempt #{@retry_count})")
        back_off(@config.retry_backoff ** @retry_count)
        retry
      else
        @config.logger.error("Abandoning request (service unavailable)")
        raise e
      end
    rescue RestClient::ResourceNotFound => e
      @config.logger.error("HTTP 404 when accessing #{full_url}")
      raise
    rescue => e
      @config.logger.error("Exception while executing request: #{e.message} <#{e.class}>")
      raise
    end

    def back_off(delay)
      sleep(delay)
    end

    private

    def should_retry
      @config.retry_503s && @retry_count < @config.max_retries
    end

    def full_url
      "#{@config.endpoint}#{@url}"
    end

    def user_agent
      "Loquor-#{VERSION}/#{@config.access_id}"
    end
  end
end

require 'loquor/http_actions/get'
require 'loquor/http_actions/post'
require 'loquor/http_actions/put'
require 'loquor/http_actions/delete'
