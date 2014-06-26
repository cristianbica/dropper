module Droppper
  class Droplet < Resource
    @collection_url   = "/v2/droplets"
    @collection_name  = "droplets"
    @resource_url     = "/v2/droplets/%{id}"
    @resource_name    = "droplet"

    attr_accessor :id, :name, :region, :image, :size, :locked, :status, :networks, :kernel, :backup_ids, :snapshot_ids, :action_ids
  end
end
