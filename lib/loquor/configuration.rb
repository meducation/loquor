module Loquor
  class LoquorError < StandardError
  end
  class LoquorConfigurationError < LoquorError
  end

  class Configuration

    SETTINGS = [
      :logger, :access_id, :secret_key, :endpoint, :substitute_values, :retry_404s, :retry_503s, :max_retries, :retry_backoff
    ]

    attr_writer *SETTINGS
    attr_accessor :cache

    def initialize
      self.logger = Filum.logger
      self.substitute_values = {}
      self.retry_404s = false
      self.retry_503s = true
      self.max_retries = 5
      self.retry_backoff = 2
    end

    SETTINGS.each do |setting|
      define_method setting do
        get_or_raise(setting)
      end
    end

    private

    def get_or_raise(setting)
      val = instance_variable_get("@#{setting.to_s}")
      raise(LoquorConfigurationError.new("Configuration for #{setting} is not set")) if val.nil?
      val
    end
  end
end

