
require 'thor'

module Droppper
  module Commands
    class Sizes < Thor
      default_command :list

      desc "list", "Retrieve the list of available sizes"
      def list(*args)
        Droppper::Sizes.list(*args)
      end
    end
  end
end
