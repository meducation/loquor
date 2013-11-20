gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "loquor"

class Minitest::Test
  def setup
    Loquor.config do |config|
      config.access_id = "Sermo"
      config.secret_key = "foobar"
      config.endpoint = "http://localhost:3000"

      config.logger = mock()
      config.logger.stubs(:debug)
      config.logger.stubs(:info)
      config.logger.stubs(:error)
    end
  end
end
