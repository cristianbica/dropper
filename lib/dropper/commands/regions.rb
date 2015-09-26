
require 'thor'

module Dropper
  module Commands
    class Regions < Thor
      default_command :list

      desc "list", "Retrieve the list regions"
      def list(*args)
        Dropper::Regions.list(*args)
      end
    end
  end
end
