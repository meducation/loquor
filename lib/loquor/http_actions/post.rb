module Loquor
  class HttpAction::Post < HttpAction
    def self.post(url, payload, deps)
      new(url, payload, deps).post
    end

    def initialize(url, payload, deps)
      super(url, deps)
      @payload = payload
    end

    def post
      @config.logger.info "Making POST request to: #{full_url}"
      response = JSON.parse(signed_request.execute)
      @config.logger.info "Signed request executed. Response: #{response}"
      Representation.new(response)
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
                              method: :post)
    end

    def full_url
      "#{@config.endpoint}#{@url}"
    end
  end
end
