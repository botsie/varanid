#!/usr/bin/env ruby

require 'optparse'

module Varanus
  class ConfigManager

    attr_accessor :directory
    
    def initialize(args=nil)
      raise Error if not args.nil? and args.class != Array
      set_defaults
      parse_options args unless args.nil? 
    end

    def set_defaults
      self.directory = "/etc/varanus"
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
  end
end
