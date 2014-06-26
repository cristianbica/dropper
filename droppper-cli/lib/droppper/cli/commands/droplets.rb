require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "Manage your DigitalOcean droplets"
command :droplets do |c|
  c.default_command :list

  c.desc "List droplets"
  c.command :list do |list|
    list.action do |global,options,args|
      r = Droppper::Droplet.all
      data = r.map do |droplet|
        row = droplet.attributes.dup
        row["ip"] = row["networks"]["v4"].select{|n| n["type"]=="public"}.first["ip_address"] rescue nil
        row["locked"] = row["locked"] ? "YES" : "NO"
        row
      end
      Formatador.display_compact_table(data, %w(id name region.name image.name ip size.slug locked status))
    end
  end

  c.desc "Show a droplet details"
  c.arg "droplet_id"
  c.command :show do |show|
    show.action do |global,options,args|
      raise "You must provide a SSH key ID" unless args.size==1
      droplet = Droppper::Droplet.find(args[0])
      puts %Q(
        Name: #{droplet.name}
        Status: #{droplet.status}
        Locked: #{droplet.locked ? 'YES' : 'NO'}
        Region: #{droplet.region["name"]} (#{droplet.region["slug"]})
        Size: #{droplet.size["slug"]}
        Distro: #{droplet.image["name"]} (#{droplet.image["slug"]})
        Kernel: #{droplet.kernel["name"]}
        Backups: #{droplet.backup_ids.size} #{"(Images IDs: "+droplet.backup_ids.join(", ")+")" if droplet.backup_ids.size>0}
        Snapshots: #{droplet.snapshot_ids.size} #{"(Images IDs: "+droplet.snapshot_ids.join(", ")+")" if droplet.snapshot_ids.size>0}
      ).split("\n").map(&:strip).join("\n")
      droplet.networks.each do |v, nets|
        nets.each do |net|
          puts %Q(
            IP#{v}(#{net["type"]})
            IP: #{net["ip_address"]}
            Netmask: #{net["netmask"]}
            Gateway: #{net["gateway"]}
          ).split("\n").map(&:strip).join("\n")
        end
      end
      puts ""
    end
  end


end
