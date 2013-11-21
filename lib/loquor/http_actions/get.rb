module Loquor
  class HttpAction::Get < HttpAction
    def self.get(url, deps)
      new(url, deps).get
    end

    def initialize(url, deps)
      super
    end

    def get
      @config.logger.info "Making GET request to: #{@url}"
      response = JSON.parse(signed_request.execute)
      @config.logger.info "Signed request executed. Response: #{response}"
      response
    end

    private
    def request
      full_url = "#{@config.endpoint}#{@url}"
      RestClient::Request.new(url: full_url, method: :get)
    end
  end
end
