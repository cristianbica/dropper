module Droppper
  class Region < Resource
    @collection_url   = "/v2/regions"
    @collection_name  = "regions"

    attr_accessor :slug, :name, :sizes, :available, :features
  end
end
