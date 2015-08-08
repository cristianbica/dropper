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
require 'droppper/commands/images'
require 'droppper/images'
require 'droppper/commands/actions'
require 'droppper/actions'
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
      # def client.connection
      #   @connection ||= Faraday.new(connection_options) do |req|
      #     req.adapter :net_http
      #     req.response :logger
      #   end
      # end
    end
  end
end

TablePrint::Config.max_width = 100
