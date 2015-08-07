require "droppper/version"
require "droppper/utils"
require "droplet_kit"
require 'table_print'
require 'highline/import'

module Droppper
  class << self
    def client
      @client
    end

    def client=(client)
      @client = client
    end

    def droplets(*args)
      args = args.flatten
      data = client.droplets.all.to_a
      if args.size > 0
        data = data.select do |d|
          (args.size==1 and (d.id.to_s == args[0] or d.name == args[0])) or (d.name =~ Regexp.new(args.join(".*")))
        end
      end
      data
    end

    def droplet(*args)
      list = droplets(*args)
      if list.size == 0
        puts "Cannot find droplet"
      elsif list.size == 1
        list.first
      else
        select_droplet(list)
      end
    end

    def select_droplet(list)
      choose do |menu|
        menu.prompt = "Multiple droplets found. Select one:"
        list.each do |droplet|
          menu.choice droplet.name do droplet end
        end
      end
    end

    def ssh(droplet, options={})
      cmd_options = [
          "-o", "IdentitiesOnly=yes",
          "-o", "LogLevel=ERROR",
          "-o", "StrictHostKeyChecking=no",
          "-o", "UserKnownHostsFile=/dev/null",
          "-i", "#{Dir.home}/.ssh/id_rsa"
      ]
      cmd_options.push "-l", "#{options[:user]}" if options[:user]
      cmd_options.push "-p", "#{options[:port]}" if options[:port]
      cmd_options << droplet.public_ip
      # puts "Executing: ssh #{cmd_options.join(" ")}"
      Kernel.exec("ssh", *cmd_options)
    end
  end
end
