require 'singleton'
require 'droppper/account'
module Droppper
  module Cmd
    class Config
      include Singleton
      attr_accessor :accounts
      attr_accessor :default_account_identifier
      def initialize
        self.accounts = {}
        self.default_account_identifier = nil
        read_config
      end

      def add_account(account)
        self.accounts[account.identifier] = account
        self.default_account = account unless default_account
      end

      def remove_account(identifier)
        self.accounts.delete identifier
        self.default_account = accounts.values.first if default_account.nil?
      end

      def default_account=(account)
        self.default_account_identifier = account ? account.identifier : nil
      end

      def default_account
        accounts[default_account_identifier]
      end

      def save_config
        FileUtils.mkdir(dir_name) unless Dir.exists?(dir_name)
        File.open(config_file_path, "w+") do |f|
          f.write serializable_config.to_yaml
        end
      end

      protected
        def read_config
          if File.exists?(config_file_path)
            data = YAML.load(File.open(config_file_path).read)
            return unless data
            data["accounts"].each do |_, account_data|
              account = Droppper::Account.new(account_data["identifier"], account_data["token"])
              self.accounts[account.identifier] = account
            end
            self.default_account_identifier = data["default_account_identifier"]
            self.default_account_identifier ||= accounts.values.first.identifier if accounts.size>0
          end
        end


        def serializable_config
          {
            "accounts" => serializable_accounts,
            "default_account_identifier" => default_account_identifier
          }
        end

        def serializable_accounts
          h = {}
          accounts.map do |k,a|
            h[k] = {"identifier" => a.identifier, "token" => a.token}
          end
          h
        end

        def dir_name
          "#{Dir.home}/.droppper"
        end

        def config_file_path
          dir_name + "/config"
        end
    end
  end
end
