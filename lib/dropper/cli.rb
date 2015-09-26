require 'thor'

module Dropper
  class CLI < Thor
    include Thor::Actions

    def initialize(args = [], local_options = {}, config = {})
      super
      Dropper.setup(options)
    end

    class_option :token, type: :string, desc: "DigitalOcean API v2 token (needed unless included in the .dropper file)"

    desc "config", "Show your current config information"
    long_desc "This shows the current information in the .dropper config files
    being used by the app. Dropper can use more than one config file the one
    being closer to the current directory having precedence.
    "
    def config
      Dropper.config.print
    end

    desc "droplets", "Actions related to droplets"
    subcommand "droplets", Dropper::Commands::Droplets

    desc "ssh [SEARCH_STRING_OR_DROPLET_ID]", "Starts a SSH to a droplet"
    method_option "user",
                  :type => :string,
                  :aliases => "-u",
                  :desc => "Specifies which user to log in as (default from .dropper files or root)"
    method_option "port",
                  :type => :string,
                  :aliases => "-p",
                  :desc => "Specifies which post to use for the ssh connection (default from .dropper files or 22)"
    def ssh(*args)
      Dropper::Droplets.ssh(*args, options)
    end

    desc "regions", "List regions"
    subcommand "regions", Dropper::Commands::Regions

    desc "sizes", "List sizes"
    subcommand "sizes", Dropper::Commands::Sizes

    desc "images", "Images manipulation"
    subcommand "images", Dropper::Commands::Images

    desc "actions", "Actions querying"
    subcommand "actions", Dropper::Commands::Actions
  end
end
