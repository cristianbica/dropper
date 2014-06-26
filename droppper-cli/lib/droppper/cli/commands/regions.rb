require 'droppper/cmd/config'
require 'droppper-core'
require 'formatador'

desc "View DigitalOcean regions"
command :regions do |c|
  c.switch :full, negatable: false, desc: "Show full region info"
  c.action do |global,options,args|
    data = Droppper::Region.all.map do |region|
      {
        "name"      => region.name,
        "slug"      => region.slug,
        "available" => region.available ? "YES" : "NO",
        "features"  => region.features.join(", "),
        "sizes"     => region.sizes.join(", "),
      }
    end
    Formatador.display_compact_table(data, options[:full] ? %w(name slug available features sizes) : %w(name slug available))
  end
end
