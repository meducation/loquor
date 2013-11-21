require 'rest-client'
require 'api-auth'
require 'filum'

require "loquor/version"
require "loquor/configuration"
require "loquor/client"
require 'loquor/path_builder'
require 'loquor/representation'
require 'loquor/representations'

require 'loquor/api_call'
require "loquor/http_action"

module Loquor
  def self.config
    if block_given?
      yield loquor.config
    else
      loquor.config
    end
  end

  def self.get(url)
    loquor.get(url)
  end

  def self.post(url, payload)
    loquor.post(url, payload)
  end

  private

  def self.loquor
    @loquor ||= Client.new
  end
end
