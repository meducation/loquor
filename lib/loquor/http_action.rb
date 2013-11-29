module Loquor
  class HttpAction
    def initialize(url, deps)
      @url = url
      @config = deps[:config]
    end

    def signed_request
      @config.logger.info "Signing request."
      ApiAuth.sign!(request, @config.access_id, @config.secret_key)
    end
  end
end

require 'loquor/http_actions/get'
require 'loquor/http_actions/post'
require 'loquor/http_actions/put'
