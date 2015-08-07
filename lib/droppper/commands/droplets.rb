desc "Manage your DigitalOcean droplets"
command :droplets do |c|
  c.default_command :list

  c.desc "List droplets"
  c.arg "search_string"
  c.command :list do |list|
    list.action do |global,options,args|
      data = Droppper.droplets(args)
      if data.size == 0
        puts "No droplets found"
      else
        tp data, {id: {display_name: "ID"}},
                 {name: {display_name: "NAME"}},
                 {"region.slug" => {display_name: "REGION"}},
                 {"size_slug" => {display_name: "SIZE"}},
                 :status,
                 :locked
      end
    end
  end

  c.desc "Show a droplet details"
  c.arg "droplet_id_or_search_string"
  c.command :show do |show|
    show.action do |global,options,args|
      droplet = Droppper.droplet(args)
      puts Droppper::Utils.print_hash droplet.as_json
      puts ""
    end
  end

  # c.desc "Create a droplet"
  # c.command :create do |create|
  #   create.flag :name, desc: "Hostname"
  #   create.flag :region, desc: "Region slug"
  #   create.flag :size, desc: "Droplet size slug"
  #   create.flag :image, desc: "Image ID or slug"
  #   create.flag :ssh_keys, desc: "Comma separated SSH keys IDs or names or fingerprint. Pass 'all' to enable all SSH keys", default: "all"
  #   create.switch :backups, default: true, desc: "Enable backups"
  #   create.switch :ipv6, default: true, desc: "Enable IPv6"
  #   create.switch :private_networking, default: true, desc: "Enable private networking"

  #   create.action do |global,options,args|
  #   end
  # end

end
