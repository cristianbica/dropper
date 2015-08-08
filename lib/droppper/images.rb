require 'time'

module Droppper
  module Images extend self
    def list(*args, options)
      data = images(args, options)
      tp data, :id, :slug,  :distribution, :name, :public, :type,
               {regions: lambda{|r| r.regions.join(", ")}}
    end

    def rename(new_name, *args)
      img = image(args)
      return unless img
      img.name = new_name
      r = Droppper.client.images.update img, id: img.id
      if r.respond_to?(:name) and r.name == new_name
        puts "Image has been successfully renamed."
      else
        puts "Failed to rename image: Response: #{r}"
      end
    end

    def destroy(*args)
      img = image(args)
      return unless img
      r = Droppper.client.images.delete id: img.id
      if r.to_s == 'true'
        puts "Image has been successfully destroyed"
      else
        puts "Failed to destroy image: Response: #{r}"
      end
    end

    def transfer(new_region, *args)
      img = image(args)
      return unless img
      r = Droppper.client.image_actions.transfer(image_id: img.id, region: new_region)
      if r and r.is_a?(DropletKit::ImageAction)
        puts "Image transfer has begin. You can see the progress by running: droppper images monitor_action #{img.id} #{r.id}"
      else
        puts "Failed to transfer image: Response: #{r}"
      end
    end

    def convert(*args)
      img = image(args)
      return unless img
      r = Droppper.client.image_actions.convert(image_id: img.id)
      if r and r.is_a?(DropletKit::ImageAction)
        puts "Image conversion has begin. You can see the progress by running: droppper images monitor_action #{img.id} #{r.id}"
      else
        puts "Failed to convert image: Response: #{r}"
      end
    end

    def actions(image_id)
      require 'pry'
      binding.pry
      r = Droppper.client.image_actions.all(image_id: image_id)
      r.each
      data = r.collection
      if data.size==0
        puts "No actions found"
        return
      end
      tp data, :id, :status, :type, :started_at, :completed_at, :resource_id, :resource_type, :region_slug
    end

    def show_action(image_id, action_id)
      act = Droppper.client.image_actions.find(image_id: image_id, id: action_id)
      puts act
    end

    def monitor_action(image_id, action_id)

    end

    def filters_for_type(type)
      case type
      when 'all'
        {}
      when 'distribution', 'dist'
        {type: :distribution}
      when 'application', 'app'
        {type: :application}
      when 'user'
        {private: :true}
      else
        {}
      end
    end

    def images(args, options={})
      data = Droppper.client.images.all(filters_for_type(options["type"])).to_a
      if args.size > 0
        re = Regexp.new(Array(args).join(".*"))
        data = data.select{|i| i.id.to_s=~re or i.name=~re or i.distribution=~re or i.slug=~re or i.type=~re or i.regions.join( )=~re}
      end
      data
    end

    def image(*args)
      list = images(args)
      if list.size == 0
        puts "Cannot find image"
      elsif list.size == 1
        list.first
      else
        select_image(list)
      end
    end

    def select_image(list)
      choose do |menu|
        menu.prompt = "Multiple droplets found. Select one:"
        list.each do |image|
          menu.choice "#{image.name} (dist: #{image.distribution}, type: #{image.type}, public: #{image.public})" do image end
        end
      end
    end
  end
end
