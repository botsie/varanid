#!/usr/bin/env ruby

require 'optparse'

module Varanid
  class Config

    attr_accessor :directory
    
    def initialize(args=nil)
      raise Error if not args.nil? and args.class != Array
      set_defaults
      parse_options args unless args.nil?
      parse_config
    end

    def set_defaults
      @data = Hash.new
      self.directory = "/etc/varanid"
    end
    
    def parse_options(args)
      opts = OptionParser.new do |opts|
        opts.on('-d', '--config-dir DIRECTORY',
                'Look in DIRECTORY for configuration') do |dir|
          self.directory = dir
        end

        opts.on_tail('-h', '--help',
                'Print this message') do |dir|
          puts opts
          exit
        end
      end
      opts.parse!(args) 
    end

    def parse_config
      pattern = File.join(self.directory, "*.json")
      Dir.glob(pattern) do |filename|
        content = File.open(filename, "r") { |f| f.read }
        config = JSON.parse content
        config.each_pair do |s_key,value|
          key = s_key.to_sym
          if self.has_key? key
            if self[key].class == Array
              if value.class == Array
                self[key] += value
              else
                self[key] << value
              end
            else
              self[key] = [self[key], value]
            end
          else
            self[key] = value
          end
        end
      end
    end

    def [](key)
      @data[key]
    end

    def []=(key, value)
      value = Varanid::Check.new(value) if key == :check
      @data[key] = value
    end

    def has_key?(key)
      @data.has_key?(key)
    end

    def checks
      if @data[:check].class == Array
        return @data[:check]
      else
        return [ @data[:check] ]
      end
    end
  end
end
