require 'droppper/cmd/config'
require 'droppper/account'

desc "Manage your DigitalOcean accounts"
command :accounts do |c|
  c.desc "List saved account on your system"
  c.command :list do |list|
    list.action do |global,options,args|
      if Droppper::Cmd::Config.instance.accounts.size==0
        puts "There are no accounts configured"
      else
        puts "Your DigitalOcean accounts:"
        Droppper::Cmd::Config.instance.accounts.each do |_, account|
          puts "#{account.identifier} #{' (default)' if Droppper::Cmd::Config.instance.default_account==account}"
        end
      end
    end
  end

  c.desc "Adds a new accounts"
  c.arg "account_name"
  c.arg "account_token"
  c.command [:add] do |add|
    add.switch :default
    add.action do |global_options,options,args|
      raise "You must provide an account name and a token" unless args.size==2
      raise "You cannot add an account named default" if args.first=="default"
      account = Droppper::Account.new(*args)
      Droppper::Cmd::Config.instance.add_account(account)
      Droppper::Cmd::Config.instance.default_account = account if options[:default]==true
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{args.first}> added"
    end
  end

  c.desc "Removes an account"
  c.arg "account_name"
  c.command :remove do |add|
    add.action do |global_options,options,args|
      raise "You must provide an account name" unless args.size==1
      Droppper::Cmd::Config.instance.remove_account(args.first)
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{args.first}> removed"
    end
  end

  c.desc "Makes an account default"
  c.arg "account_name"
  c.command :default do |add|
    add.action do |global_options,options,args|
      raise "You must provide an account name" unless args.size==1
      account = Droppper::Cmd::Config.instance.accounts[args.first]
      Droppper::Cmd::Config.instance.default_account = account
      Droppper::Cmd::Config.instance.save_config
      puts "Account <#{args.first}> marked as default"
    end
  end
end
