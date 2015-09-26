require 'time'

module Dropper
  module Sizes extend self
    def list(*args)
      data = Dropper.client.sizes.all.to_a
      tp data, :slug, :memory, :vcpus, :disk, :transfer, :price_monthly, :price_hourly,
               {regions: lambda{|r| r.regions.join(", ")}},
               :available
    end
  end
end
