module Loquor
  class Gets
    def self.get(url, deps)
      new(url, deps).get
    end

    def initialize(url, deps)
      @url = url
      @config = deps[:config]
    end

    def get
      JSON.parse(signed_request.execute)
    end

    private
    def signed_request
      ApiAuth.sign!(request, @config.access_id, @config.secret_key)
    end

    def request
      full_url = "#{@config.endpoint}#{@url}"
      RestClient::Request.new(url: full_url, method: :get)
    end
  end
end

