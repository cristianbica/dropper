require 'thor'

module Droppper
  module Commands
    class Droplets < Thor
      default_command :list

      desc "list [SEARCH_STRING_OR_DROPLET_ID]", "Retrieve a list of your droplets"
      def list(*args)
        Droppper::Droplets.list(*args)
      end

      desc "show [SEARCH_STRING_OR_DROPLET_ID]", "Show full details about a droplet"
      def show(*args)
        Droppper::Droplets.show(*args)
      end

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
end
