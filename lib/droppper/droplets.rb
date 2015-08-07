require 'time'

module Droppper
  module Droplets extend self

    def list(*args)
      data = droplets(*args)
      tp data, {id: {display_name: "ID"}},
               {name: {display_name: "NAME"}},
               {"region.slug" => {display_name: "REGION"}},
               {"size_slug" => {display_name: "SIZE"}},
               :status,
               :locked
    end

    def show(*args)
      d = droplet(*args)
      puts <<-eos
ID: #{d.id}
Name: #{d.name}
Memory: #{d.memory}MB
vCPUs: #{d.vcpus}
Disk: #{d.disk}G
Created on: #{Time.parse(d.created_at).rfc2822}
Status: #{d.status}
Backups: #{d.backup_ids.size}
Features: #{d.features.join(", ")}
Region: #{d.region.name}
Image: #{d.image.name}
Kernel: #{d.kernel.name}
      eos
      puts "Networking:"
      [['v4', 'public'], ['v4', 'private'], ['v6', 'public'], ['v6', 'private']].each do |pair|
        version, publicity = pair
        if net = d.networks.send(version).find{|net| net.type == publicity}
           puts "  IP#{version} (#{publicity}):".ljust(18) +"#{net.ip_address}"
        end
      end
    end

    def ssh(*args, options)
      d = droplet(*args)
      cmd_options = [
          "-o", "IdentitiesOnly=yes",
          "-o", "LogLevel=ERROR",
          "-o", "StrictHostKeyChecking=no",
          "-o", "UserKnownHostsFile=/dev/null",
          "-i", File.expand_path(Droppper.config.ssh.keyfile)
      ]
      cmd_options.push "-l", "#{options['user']||Droppper.config.ssh.user}"
      cmd_options.push "-p", "#{options['port']||Droppper.config.ssh.port}"
      cmd_options << d.public_ip
      puts "Executing: ssh #{cmd_options.join(" ")}"
      Kernel.exec("ssh", *cmd_options)
    end

    def droplets(*args)
      args = Array(args).flatten
      data = Droppper.client.droplets.all.to_a
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
  end
end
