module Droppper
  class Image < Resource
    @collection_url   = "/v2/images"
    @collection_name  = "images"
    @resource_url     = "/v2/images/%{id}"
    @resource_name    = "image"

    attr_accessor :id, :name, :distribution, :slug, :public, :regions, :created_at

    def transfer_to(region_slug)
      resource_url = self.class.resource_url%symbolized_attributes
      puts "Posting #{{type: "transfer", region: region_slug}.inspect} to #{resource_url}/actions"
      response = Droppper::client.post "#{resource_url}/actions", {type: "transfer", region: region_slug}
      raise "Cannot perform this action" if response.size==0
      action = Droppper::Action.new_from_response response
      action
    end
  end
end
