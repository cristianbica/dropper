require 'dropper/version'
require 'dropper/utils'
require 'dropper/config'
require 'droplet_kit'
require 'hashie/mash'
require 'dropper/commands/droplets'
require 'dropper/droplets'
require 'dropper/commands/regions'
require 'dropper/regions'
require 'dropper/commands/sizes'
require 'dropper/sizes'
require 'dropper/commands/images'
require 'dropper/images'
require 'dropper/commands/actions'
require 'dropper/actions'
require 'dropper/cli'
require 'highline/import'
require 'table_print'

module Dropper
  class << self
    attr_accessor :client, :config

    def setup(options)
      self.config = Dropper::Config.new
      self.config.token = options["token"] if options["token"]
      self.client = DropletKit::Client.new(access_token: config.token)
    end
  end
end

TablePrint::Config.max_width = 100
