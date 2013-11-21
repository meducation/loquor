module Loquor
  class HttpAction
    def initialize(url, deps)
      @url = url
      @config = deps[:config]
    end

    def signed_request
      @config.logger.info "Signing request."
      ApiAuth.sign!(request, @config.access_id, @config.secret_key)
      @config.logger.info "Signed request."
    end
  end
end

require 'loquor/http_actions/get'
require 'loquor/http_actions/post'

