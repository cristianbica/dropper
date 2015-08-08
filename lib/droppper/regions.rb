require 'time'

module Droppper
  module Regions extend self
    def list(*args)
      data = Droppper.client.regions.all.to_a
      tp data, :slug, :name, {sizes: lambda{|r| r.sizes.join(", ")}}, :available, {features: lambda{|r| r.features.join(", ")}}
    end
  end
end
