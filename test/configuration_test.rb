require File.expand_path('../test_helper', __FILE__)

module Loquor
  class ConfigurationTest < Minitest::Test

    def setup
      Loquor.send(:loquor).instance_variable_set("@config", Configuration.new)
    end

    def test_obtaining_singletion
      refute Loquor.config.nil?
    end

    def test_block_syntax
      test_key = "foobar-123-access"
      Loquor.config do |config|
        config.access_id = test_key
      end
      assert_equal test_key, Loquor.config.access_id
    end

    def test_access_id
      access_id = "test-access-key"
      Loquor.config.access_id = access_id
      assert_equal access_id, Loquor.config.access_id
    end

    def test_secret_key
      secret_key = "test-secret-key"
      Loquor.config.secret_key = secret_key
      assert_equal secret_key, Loquor.config.secret_key
    end

    def test_endpoint
      endpoint = "http://localhost:3000"
      Loquor.config.endpoint = endpoint
      assert_equal endpoint, Loquor.config.endpoint
    end

    def test_missing_access_id_throws_exception
      assert_raises(LoquorConfigurationError) do
        Loquor.config.access_id
      end
    end

    def test_missing_secret_key_throws_exception
      assert_raises(LoquorConfigurationError) do
        Loquor.config.secret_key
      end
    end

    def test_missing_endpoint_throws_exception
      assert_raises(LoquorConfigurationError) do
        Loquor.config.endpoint
      end
    end
      
    def test_can_load_secret_key_from_file
      Loquor.config.secret_key_file = File.expand_path('test/etc/loquor-identity')
      assert_equal "secret-key-from-file", Loquor.config.secret_key
    end
    
    def test_should_default_to_filum_logger
      assert_equal Filum.logger, Loquor.config.logger
    end
    
    def test_can_override_logger
      my_logger = Logger.new(nil)
      Loquor.config.logger = my_logger
      assert_equal my_logger, Loquor.config.logger
    end
  end
end
