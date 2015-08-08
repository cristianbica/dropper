require 'time'

module Droppper
  module Sizes extend self
    def list(*args)
      data = Droppper.client.sizes.all.to_a
      tp data, :slug, :memory, :vcpus, :disk, :transfer, :price_monthly, :price_hourly,
               {regions: lambda{|r| r.regions.join(", ")}},
               :available
    end
  end
end
