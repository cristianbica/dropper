require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "Manage your DigitalOcean images"
command :images do |c|
  c.default_command :list

  c.desc "List images"
  c.command :list do |list|
    list.flag :records, desc: "Number of maximum images info to retrieve", default_value: 100
    list.action do |global,options,args|
      col = Droppper::Image.all(per_page: options[:records])
      data = col.map do |image|
        row = image.attributes.dup
        row["regions"] = row["regions"].join(", ")
        row["public"]  = row["public"] ? "YES" : "NO"
        row
      end
      r =
      Formatador.display_compact_table(data, %w(id slug name distribution public regions created_at))
      puts "Displayed #{col.size} images out of #{col.total_records} (use the --records flag to show more)"
    end
  end

  c.desc "Update an image name"
  c.arg "id_or_slug"
  c.arg "new_name"
  c.command :rename do |a|
    a.action do |global_options,options,args|
      raise "You must provide an image ID or slug and a new_name" unless args.size==2 or args.last.size==0
      image = Droppper::Image.find(args[0])
      puts "Renaming <#{image.name}> to <#{args.last}> ..."
      image.update name: args.last
      puts "DONE"
    end
  end

  c.desc "Remove an image"
  c.arg "id_or_slug"
  c.command :remove do |add|
    add.action do |global_options,options,args|
      raise "You must provide an image ID or slug " unless args.size==1 or args.last.size==0
      image = Droppper::Image.find(args[0])
      puts "Removing image <#{image.name}>..."
      image.destroy
      puts "Image removed"
    end
  end

  c.desc "Transfer an image to another region"
  c.arg "id_or_slug"
  c.arg "region_slug"
  c.command :transfer do |add|
    add.switch :wait, desc: "Wait for the transfer to finish", default_value: true
    add.action do |global_options,options,args|
      raise "You must provide an image ID or slug and a region slug" unless args.size==2
      image  = Droppper::Image.find(args[0])
      region = Droppper::Region.all.select{|region| region.slug == args[1]}.first
      raise "Cannot find a region named <#{args[1]}>" unless region
      action = image.transfer_to(region.slug)
      puts "Beging transferring image <#{image.name}> to region <#{region.slug}> (Action ID: #{action.id})"
      if options[:wait]
        print "Waiting for the action to finish (you can exit anytime with ^C) "
        finished = false
        while not finished do
          sleep 5
          print "."
          action.refresh
          finished = (action.status != "in-progress")
        end
        puts " DONE"
      end
    end
  end
end
