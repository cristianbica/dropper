require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "View your DigitalOcean actions"
command :actions do |c|
  c.default_command :list

  c.desc "List actions"
  c.command :list do |list|
    list.action do |global,options,args|
      r = Droppper::Action.all
      Formatador.display_compact_table(r.map(&:attributes), %w(id status type started_at completed_at resource_id resource_type region))
    end
  end

  c.desc "Monitor an action until it's status is not in-progress"
  c.arg "action_id"
  c.command :monitor do |add|
    add.action do |global_options,options,args|
      raise "You must provide an action_id" unless args.size>0
      action = Droppper::Action.find(args[0])
      puts "Beging monitoring action #{action.id} ..."
      while action.status=="in-progress" do
        sleep 5
        action.refresh
        puts "Current status: #{action.status}"
      end
      puts " DONE"
    end
  end
end
