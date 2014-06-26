require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "Manage your DigitalOcean SSH Keys"
command :keys do |c|
  c.desc "List keys"
  c.command :list do |list|
    list.action do |global,options,args|
      r = Droppper::SshKey.all
      Formatador.display_table(r.map(&:attributes), %w(id name fingerprint))
    end
  end

  c.desc "Adds a new SSH key"
  c.arg "name"
  c.arg "public_key"
  c.command [:add] do |add|
    add.action do |global_options,options,args|
      raise "You must provide a key name and a public_key" unless args.size==2
      key = Droppper::SshKey.create(name: args[0], public_key: args[1])
      puts "SSH key <#{key.name}> created: #{key.inspect}"
    end
  end

  c.desc "Removes a SSH key"
  c.arg "key_id"
  c.command :remove do |add|
    add.action do |global_options,options,args|
      raise "You must provide a SSH key ID" unless args.size==1
      Droppper::SshKey.destroy(id: args[0])
      puts "SSH key removed"
    end
  end
end
