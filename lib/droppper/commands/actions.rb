
require 'thor'

module Droppper
  module Commands
    class Actions < Thor
      default_command :list

      desc "list [SEARCH_STRING]", "Retrieve the list of actions"
      def list(*args)
        Droppper::Actions.list(*args)
      end

      desc "status [ACTION_ID]", "Shows the status of an action"
      def status(action_id)
        Droppper::Actions.status(action_id)
      end

      desc "monitor [ACTION_ID]", "Shows the status of an action and waits until the action finishes"
      def monitor(action_id)
        Droppper::Actions.monitor(action_id)
      end
    end
  end
end
