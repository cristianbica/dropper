module Droppper
  class Action < Resource
    @collection_url   = "/v2/actions"
    @collection_name  = "actions"
    @resource_url     = "/v2/actions/%{id}"
    @resource_name    = "action"

    attr_accessor :id, :status, :type, :started_at, :completed_at, :resource_id, :resource_type, :region
  end
end
