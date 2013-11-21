module Loquor
  class HttpAction::Get < HttpAction
    def self.get(url, deps)
      new(url, deps).get
    end

    def initialize(url, deps)
      super
    end

    def get
      JSON.parse(signed_request.execute)
    end

    private
    def request
      full_url = "#{@config.endpoint}#{@url}"
      RestClient::Request.new(url: full_url, method: :get)
    end
  end
end

