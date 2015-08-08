
require 'thor'

module Droppper
  module Commands
    class Regions < Thor
      default_command :list

      desc "list", "Retrieve the list regions"
      def list(*args)
        Droppper::Regions.list(*args)
      end
    end
  end
end
