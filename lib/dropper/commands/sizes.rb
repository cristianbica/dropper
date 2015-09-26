
require 'thor'

module Dropper
  module Commands
    class Sizes < Thor
      default_command :list

      desc "list", "Retrieve the list of available sizes"
      def list(*args)
        Dropper::Sizes.list(*args)
      end
    end
  end
end
