require 'thor'

module Dropper
  module Commands
    class Droplets < Thor
      default_command :list

      desc "list [SEARCH_STRING_OR_DROPLET_ID]", "Retrieve a list of your droplets"
      def list(*args)
        Dropper::Droplets.list(*args)
      end

      desc "show [SEARCH_STRING_OR_DROPLET_ID]", "Show full details about a droplet"
      def show(*args)
        Dropper::Droplets.show(*args)
      end

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
    end
  end
end
