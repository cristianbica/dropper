require 'highline/import'

module Droppper
  module Cmd
    class Interactive
      def initialize(command, options, arguments)
        @command   = command
        @options   = options
        @arguments = arguments
      end

      def run
        @command.flags_declaration_order.each do |flag|
          puts flag.inspect
          default_value = @options[flag.name].size>0 ? @options[flag.name] : flag.default_value
          @options[flag.name] = @options[flag.name.to_s] = case flag.argument_name
          when "account_name" then ask_account_name(flag)
          else ask("#{flag.description}? ", flag.type){|q| q.default = default_value }
          end.to_s
        end
      end

      protected
        def ask_account_name(flag)
          choose do |menu|
            menu.prompt = "#{flag.description}?"
            Droppper::Cmd::Config.instance.accounts.each do |_, account|
              menu.choice account.identifier do account.identifier end
            end
          end
        end
    end
  end
end
