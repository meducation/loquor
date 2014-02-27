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

    def test_retry_404s_should_be_false_by_default
      assert_equal false, Loquor.config.retry_404s
    end

    def test_retry_404s_should_set_to_false
      retry_404s = false
      Loquor.config.retry_404s = retry_404s
      assert_equal retry_404s, Loquor.config.retry_404s
    end

    def test_retry_404s_should_set_to_false
      retry_404s = true
      Loquor.config.retry_404s = retry_404s
      assert_equal retry_404s, Loquor.config.retry_404s
    end

    def test_substitute_values
      substitute_values = {foo: 'bar'}
      Loquor.config.substitute_values = substitute_values
      assert_equal substitute_values, Loquor.config.substitute_values
    end

    def test_substitute_values_writable
      Loquor.config.substitute_values[:foo] = "bar"
      assert_equal "bar", Loquor.config.substitute_values[:foo]
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
  end
end
