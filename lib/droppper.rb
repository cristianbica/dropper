require 'droppper/version'
require 'droppper/utils'
require 'droppper/config'
require 'droplet_kit'
require 'hashie/mash'
require 'droppper/commands/droplets'
require 'droppper/droplets'
require 'droppper/commands/regions'
require 'droppper/regions'
require 'droppper/commands/sizes'
require 'droppper/sizes'
require 'droppper/cli'
require 'highline/import'
require 'table_print'

module Droppper
  class << self
    attr_accessor :client, :config

    def setup(options)
      self.config = Droppper::Config.new
      self.config.token = options["token"] if options["token"]
      self.client = DropletKit::Client.new(access_token: config.token)
    end
  end
end

TablePrint::Config.max_width = 100
