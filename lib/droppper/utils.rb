module Droppper
  module Utils extend self
    def print_hash(hash, include_empty=false)
      lines = []
      recursive_flatten_hash(hash).each do |key, value|
        lines << "#{key.upcase}: #{value}" if include_empty || value.present?
      end
      lines.join("\n")
    end

    def recursive_flatten_hash(hash)
      h = {}
      hash.each do |key, value|
        if value.is_a?(Array)
          value = value.map.with_index{|v, i| {i => v} }.inject(&:merge)
        end
        if value.is_a?(Hash)
          recursive_flatten_hash(value).each do |key2, value2|
            h["#{key}.#{key2}"] = value2
          end
        else
          h[key] = value
        end
      end
      h
    end
  end
end
