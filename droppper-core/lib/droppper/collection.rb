module Droppper
  class Collection < Array
    attr_accessor :model
    attr_accessor :meta
    attr_accessor :links
    attr_accessor :per_page

    def initialize(options = {})
      self.model    = options[:model] || raise("You need to provide a model when creating a #{self.class.name}")
      self.per_page = options[:per_page] || 10
    end

    def fetch(params={})
      url    = next_page_url(params)
      result = Droppper.client.get(url)
      process_result(result)
      self
    end

    def has_more_records?
      meta and meta["total"].to_i > self.size
    end

    def total_records
      (meta and meta["total"]) ? meta["total"].to_i : self.size
    end

    protected
      def next_page_url(params)
        if links and links["pages"] and links["pages"]["next"]
          links["pages"]["next"]
        else
          model.collection_url + "?" + URI.encode_www_form(params.merge(per_page: self.per_page))
        end
      end

      def process_result(result)
        puts "Processing result: #{result.inspect}"
        result = JSON.parse(result)
        if result[model.collection_name] and result[model.collection_name].is_a?(Array)
          result[model.collection_name].each do |record|
            self << model.new(record)
          end
        end
        self.meta  = result["meta"]
        self.links = result["links"]
      end

  end
end
