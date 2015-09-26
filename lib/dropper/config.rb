module Dropper
  class Config
    attr_accessor :data, :files

    DEFAULT = {
      token: nil,
      ssh: {
        user: "root",
        port: "22",
        keyfile: "~/.ssh/id_rsa"
      },
      create: {
        region: "nyc3",
        image: "ubuntu-14-04-x64",
        size: "512mb",
        keys: []
      }
    }

    def initialize
      load_config
    end

    def print
      puts Dropper::Utils.print_hash(data)
    end

    def token
      data.token
    end

    def token=(new_token)
      data.token = new_token
    end

    def ssh
      data.ssh
    end

    def create
      data.create
    end

    protected
      def load_config
        find_config_files
        parse_config_files
      end

      def find_config_files
        self.files = []
        root = Dir.pwd
        while root != '/'
          add_file File.expand_path(".dropper", root)
          add_file File.expand_path(".droppper", root)
          root = File.expand_path("..", root)
        end
        add_file File.join(File.expand_path("~"), ".dropper")
        add_file File.join(File.expand_path("~"), ".droppper")
      end

      def parse_config_files
        self.data = Hashie::Mash.new(DEFAULT)
        files.reverse.each do |file|
          self.data.deep_merge! parse_config_file(file)
        end
      end

      def parse_config_file(file)
        require 'yaml'
        YAML.load_file(file)
      rescue
        {}
      end

      def add_file(f)
        files << f if File.exists?(f)
      end
  end
end
