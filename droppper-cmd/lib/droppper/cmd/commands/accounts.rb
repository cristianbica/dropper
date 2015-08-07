require 'droppper/cmd/config'
require 'droppper/account'

desc "Manage your DigitalOcean accounts"
command :accounts do |c|
  c.default_command :list

  c.desc "List saved account on your system"
  c.command :list do |cmd|
    cmd.action do |global,options,args|
      if Droppper::Cmd::Config.instance.accounts.size==0
        puts "There are no accounts configured"
      else
        data = []
        Droppper::Cmd::Config.instance.accounts.each do |_, account|
          data << {identifier: account.identifier, token: account.token, default: "#{'YES' if Droppper::Cmd::Config.instance.default_account==account}"}
        end
        Formatador.display_compact_table data
      end
    end
  end

  c.desc "Adds a new accounts"
  c.command [:add] do |cmd|
    cmd.switch :default, desc: "Make this new account the default one"
    cmd.flag :name, desc: "Account name", arg_name: "name", default_value: "", type: String
    cmd.flag :token, desc: "Account API v2 token", arg_name: "token", default_value: "", type: String
    cmd.action do |global_options,options,args|
      Droppper::Cmd::Interactive.new(cmd, options, args).run if global_options[:interactive]
      help_now! "You must provide an account name and a token" unless options[:name].to_s.size>0 and options[:token].to_s.size>0
      help_now! "You cannot add an account named default" if options[:name]=="default"
      puts options.inspect
      account = Droppper::Account.new(options[:name], options[:token])
      Droppper::Cmd::Config.instance.add_account(account)
      Droppper::Cmd::Config.instance.default_account = account if options[:default]==true
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{account.identifier}> added"
    end
  end

  c.desc "Removes an account"
  c.command :remove do |cmd|
    cmd.flag :name, desc: "Account name", arg_name: "account_name", default_value: "", type: String
    cmd.action do |global_options,options,args|
      Droppper::Cmd::Interactive.new(cmd, options, args).run if global_options[:interactive]
      help_now! "You must provide an account name" unless options[:name].to_s.size>0
      Droppper::Cmd::Config.instance.remove_account(options[:name])
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{options[:name]}> removed"
    end
  end

  c.desc "Makes an account default"
  c.command :default do |cmd|
    cmd.flag :name, desc: "Account name", arg_name: "account_name", default_value: "", type: String
    cmd.action do |global_options,options,args|
      Droppper::Cmd::Interactive.new(cmd, options, args).run if global_options[:interactive]
      help_now! "You must provide an account name" unless options[:name].to_s.size>0
      account = Droppper::Cmd::Config.instance.accounts[options[:name]]
      Droppper::Cmd::Config.instance.default_account = account
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{account.identifier}> marked as default"
    end
  end
end
