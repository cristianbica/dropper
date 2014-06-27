require 'highline/import'

module Droppper
  module Cmd
    class Interactive
      def initialize(command, options, arguments)
        @command   = command
        @options   = options
        @arguments = @arguments
      end

      def run
        @command.flags_declaration_order.each do |flag|
          default_value = @options[flag.name].size>0 ? @options[flag.name] : flag.default_value
          @options[flag.name] = @options[flag.name.to_s] = ask("#{flag.description}? ", flag.type){|q| q.default = default_value }
        end
      end
    end
  end
end
