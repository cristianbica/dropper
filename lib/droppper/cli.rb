require 'thor'

module Droppper
  class CLI < Thor
    include Thor::Actions

    def initialize(args = [], local_options = {}, config = {})
      super
      Droppper.setup(options)
    end

    class_option :token, type: :string, desc: "DigitalOcean API v2 token (needed unless included in the .droppper file)"

    desc "config", "Show your current config information"
    long_desc "This shows the current information in the .droppper config files
    being used by the app. Droppper can use more than one config file the one
    being closer to the current directory having precedence.
    "
    def config
      Droppper.config.print
    end

    desc "droplets", "Actions related to droplets"
    subcommand "droplets", Droppper::Commands::Droplets

    desc "ssh [SEARCH_STRING_OR_DROPLET_ID]", "Starts a SSH to a droplet"
    method_option "user",
                  :type => :string,
                  :aliases => "-u",
                  :desc => "Specifies which user to log in as (default from .droppper files or root)"
    method_option "port",
                  :type => :string,
                  :aliases => "-p",
                  :desc => "Specifies which post to use for the ssh connection (default from .droppper files or 22)"
    def ssh(*args)
      Droppper::Droplets.ssh(*args, options)
    end
  end
end
