module Droppper
  class Size < Resource
    @collection_url   = "/v2/sizes"
    @collection_name  = "sizes"

    attr_accessor :slug, :memory, :vcpus, :disk, :transfer, :price_monthly, :price_hourly, :regions
  end
end
