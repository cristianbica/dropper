require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "View DigitalOcean droplets sizes"
command :sizes do |c|
  c.switch :full, negatable: false, desc: "Show full size info"
  c.action do |global,options,args|
    data = Droppper::Size.all.map do |size|
      row = size.attributes.dup
      row["regions"]       = row["regions"].join(", ")
      row["memory"]        = "#{row["memory"]} MB"
      row["disk"]          = "#{row["disk"]} GB"
      row["transfer"]      = "#{row["transfer"]} TB"
      row["price_monthly"] = "$#{row["price_monthly"].to_i}"
      row["price_hourly"]  = "$#{row["price_hourly"].to_f.round(4)}"
      row
    end

    Formatador.display_compact_table(data, options[:full] ? %w(slug memory vcpus disk transfer price_monthly) : %w(slug memory vcpus disk transfer price_monthly price_hourly regions))
  end
end
