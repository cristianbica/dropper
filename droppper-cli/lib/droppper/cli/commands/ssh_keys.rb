require 'droppper/cmd/config'
require 'droppper/cmd/interactive'
require 'droppper-core'
require 'formatador'

desc "Manage your DigitalOcean SSH Keys"
command :keys do |c|
  c.default_command :list

  c.desc "List keys"
  c.command :list do |list|
    list.action do |global,options,args|
      r = Droppper::SshKey.all
      Formatador.display_compact_table(r.map(&:attributes), %w(id name fingerprint))
    end
  end

  c.desc "Adds a new SSH key"
  c.command [:add] do |add|
    add.flag :name, desc: "SSH key name", arg_name: "name", default_value: "", type: String
    add.flag :public_key, desc: "SSH public key", arg_name: "public_key", default_value: "", type: String
    add.action do |global_options,options,args|
      Droppper::Cmd::Interactive.new(add, options, args).run if global_options[:interactive]
      help_now! "You must provide a key name and a public_key" unless options[:name].to_s.size>0 and options[:public_key].to_s.size>0
      key = Droppper::SshKey.create(name: options[:name], public_key: options[:public_key])
      puts "SSH key <#{key.name}> created"
    end
  end

  c.desc "Removes a SSH key"
  c.command :remove do |remove|
    remove.flag :id, desc: "SSH key ID", arg_name: "key_id", default_value: "", type: String
    remove.action do |global_options,options,args|
      Droppper::Cmd::Interactive.new(remove, options, args).run if global_options[:interactive]
      help_now! "You must provide a SSH key ID" unless options[:id].to_s.size>0
      Droppper::SshKey.destroy(options[:id])
      puts "SSH key removed"
    end
  end
end
