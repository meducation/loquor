require 'rest-client'
require 'api-auth'
require 'filum'

require "loquor/version"
require "loquor/configuration"
require "loquor/client"
require 'loquor/object_hash'
require 'loquor/resource'
require 'loquor/resource_mock'

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

  def self.get(url, *args)
    loquor.get(url, *args)
  end

  def self.put(url, payload)
    loquor.put(url, payload)
  end

  def self.post(url, payload)
    loquor.post(url, payload)
  end

  def self.delete(url)
    loquor.delete(url)
  end

  private

  def self.loquor
    @loquor ||= Client.new
  end
end
