module Droppper
  class Collection < Array
    attr_accessor :model
    attr_accessor :meta
    attr_accessor :per_page

    def initialize(options = {})
      self.model    = options[:model] || raise("You need to provide a model when creating a #{self.class.name}")
      self.per_page = options[:per_page] || 10
    end

    def load_next(params={})
      url    = next_page_url(params)
      result = Droppper.client.get(url)
      process_result(result)
      self
    end

    protected
      def next_page_url(params)
        if meta and meta["links"] and meta["links"]["pages"] and meta["links"]["pages"]["next"]
          meta["links"]["pages"]["next"]
        else
          model.collection_url + URI.encode_www_form(params)
        end
      end

      def process_result(result)
        result = JSON.parse(result)
        if result[model.collection_name] and result[model.collection_name].is_a?(Array)
          result[model.collection_name].each do |record|
            self << model.new(record)
          end
        end
        self.meta = result["meta"]
      end

  end
end
