module Loquor
  class Client
    attr_reader :config

    def initialize
      @config = Configuration.new
    end

    def get(url, options = {})
      deps = {config: @config}
      deps[:should_cache] = options[:cache] if options[:cache]
      HttpAction::Get.get(url, deps)
    end

    def put(url, payload)
      deps = {config: @config}
      HttpAction::Put.put(url, payload, deps)
    end

    def post(url, payload)
      deps = {config: @config}
      HttpAction::Post.post(url, payload, deps)
    end

    def delete(url)
      deps = {config: @config}
      HttpAction::Delete.delete(url, deps)
    end
  end
end
