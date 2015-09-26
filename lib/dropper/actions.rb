require 'time'

module Dropper
  module Actions extend self
    def list(*args)
      data = actions(args)
      tp data, :id, :status, :type, :started_at, :completed_at, :resource_id, :resource_type, :region_slug
    end

    def status(action_id)
      act = action(action_id)
      puts act.inspect
    end

    def actions(args)
      pr = Dropper.client.actions.all(page:1, per_page: 25)
      pr.each
      data = pr.collection
      if args.size > 0
        re = Regexp.new(Array(args).join(".*"))
        data = data.select{|i| i.id.to_s=~re or i.status=~re or i.type=~re or i.resource_type=~re}
      end
      data
    end

    def action(action_id)
      Dropper.client.actions.find id: action_id
    end
  end
end
