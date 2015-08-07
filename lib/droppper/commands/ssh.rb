desc "SSH to your DigitalOcean droplets"
command :ssh do |cmd|
  cmd.flag [:u, :user], desc: "SSH Username", default_value: 'deploy'
  cmd.flag [:p, :port], desc: "SSH Port", default_value: '22'

  cmd.action do |global,options,args|
    droplet = Droppper.droplet(args)
    if droplet
      Droppper.ssh droplet, user: options[:user], port: options[:port]
    else
      puts "Cannot find any droplet"
    end
  end
end
