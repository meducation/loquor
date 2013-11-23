require 'rest-client'
require 'api-auth'
require 'filum'

require "loquor/version"
require "loquor/configuration"
require "loquor/client"
require 'loquor/interactor'
require 'loquor/representation'

require 'loquor/api_call'
require "loquor/http_action"

module Loquor

  Interactors = {
    "GroupDiscussion"     => "/group_discussions",
    "GroupDiscussionPost" => "/group_discussion_posts",
    "MediaFile"           => "/media_files",
    "MeshHeading"         => "/mesh_headings",
    "Mnemonic"            => "/mnemonics",
    "PremiumTutorial"     => "/premium_tutorials",
    "Partner"             => "/partners",
    "SyllabusItem"        => "/syllabus_items",
    "User"                => "/users"
  }

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

require 'loquor/interactors'
