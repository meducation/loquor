module Loquor
  class HttpAction::Delete < HttpAction
    def self.delete(url, deps)
      new(url, deps).delete
    end

    def initialize(url, deps)
      super(url, deps)
    end

    def delete
      @config.logger.info "Making DELETE request to: #{full_url}"
      response = JSON.parse(signed_request.execute)
      @config.logger.info "Signed request executed. Response: #{response}"
      response
    end

    private

    def request
      RestClient::Request.new(url: full_url,
                              accept: :json,
                              headers: {'Content-type' => 'application/json'},
                              method: :delete)
    end

    def full_url
      "#{@config.endpoint}#{@url}"
    end
  end
end
