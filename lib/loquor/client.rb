module Loquor
  class Client
    attr_reader :config

    def initialize
      @config = Configuration.new
    end

    def get(url)
      deps = {config: @config}
      Loquor::Gets.get(url, deps)
    end

    def post(url, payload)
      deps = {config: @config}
      Loquor::Posts.post(url, payload, deps)
    end
  end
end
