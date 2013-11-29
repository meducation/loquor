module Loquor
  class HttpAction::Put < HttpAction
    def self.put(url, payload, deps)
      new(url, payload, deps).put
    end

    def initialize(url, payload, deps)
      super(url, deps)
      @payload = payload
    end

    def put
      @config.logger.info "Making put request to: #{full_url}"
      response = JSON.parse(signed_request.execute)
      @config.logger.info "Signed request executed. Response: #{response}"
      Resource.new(response)
    end

    private

    def signed_request
      signed_request = super
      p signed_request # If you take this line out - it all breaks. Yeah...
      signed_request
    end

    def request
      RestClient::Request.new(url: full_url,
                              accept: :json,
                              payload: @payload.to_json,
                              headers: {'Content-type' => 'application/json'},
                              method: :put)
    end

    def full_url
      "#{@config.endpoint}#{@url}"
    end
  end
end

