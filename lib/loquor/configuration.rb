module Loquor
  class LoquorError < StandardError
  end
  class LoquorConfigurationError < LoquorError
  end

  class Configuration

    SETTINGS = [
      :logger, :access_id, :secret_key, :endpoint
    ]

    attr_writer *SETTINGS

    def initialize
      Filum.config do |config|
        config.logfile = "./log/loquor.log"
      end
      logger = Filum.logger
    end

    SETTINGS.each do |setting|
      define_method setting do
        get_or_raise(setting)
      end
    end

    def secret_key_file=(value)
      @secret_key = File.read(value)
    end

    private

    def get_or_raise(setting)
      instance_variable_get("@#{setting.to_s}") ||
        raise(LoquorConfigurationError.new("Configuration for #{setting} is not set"))
    end
    
  end
end

