module Loquor
  class LoquorError < StandardError
  end
  class LoquorConfigurationError < LoquorError
  end

  class Configuration

    SETTINGS = [
      :logger, :access_id, :secret_key, :endpoint, :substitute_values
    ]

    attr_writer *SETTINGS
    attr_accessor :cache

    def initialize
      Filum.config do |config|
        config.logfile = "./log/loquor.log"
      end
      self.logger = Filum.logger
      self.substitute_values = {}
    end

    SETTINGS.each do |setting|
      define_method setting do
        get_or_raise(setting)
      end
    end

    private

    def get_or_raise(setting)
      instance_variable_get("@#{setting.to_s}") ||
        raise(LoquorConfigurationError.new("Configuration for #{setting} is not set"))
    end
  end
end

