module Droppper
  module Utils extend self
    def find_token
      f = find_dot_dropper_file
      File.open(f).read.strip if f
    end

    def find_dot_dropper_file
      find_nearest_dot_dropper_file || default_drop_droppper_file
    end

    def find_nearest_dot_dropper_file(root=Dir.pwd)
      f = File.expand_path ".droppper", root
      return f if File.exists?(f)
      return nil if root=='/'
      find_nearest_dot_dropper_file(File.expand_path("..", root))
    end

    def default_drop_droppper_file
      f = File.join(File.expand_path("~"), ".droppper")
      return f if File.exists?(f)
    end

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
