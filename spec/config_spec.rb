#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanus/config_manager'
require "spec_helper.rb"

describe Varanus::ConfigManager do
  it "can be instantiated" do
    expect { c = Varanus::ConfigManager.new() }.to_not raise_error
  end

  it "can be instantiated with an argument" do
    args = Array.new
    expect { c = Varanus::ConfigManager.new(args) }.to_not raise_error    
  end

  it "should only accept an array as an argument" do
    args = ""
    expect { c = Varanus::ConfigManager.new(args) }.to raise_error    
  end

  it "should accept --config-dir argument" do
    args = ["--config-dir"]
    expect { c = Varanus::ConfigManager.new(args) }.to_not raise_error(OptionParser::InvalidOption) 
  end

  it "should accept --help argument" do
    args = ["--help"]
    expect { c = Varanus::ConfigManager.new(args) }.to_not raise_error(OptionParser::InvalidOption)    
  end

  it "should not accept any other argument" do
    args = ["--foo"]
    expect { c = Varanus::ConfigManager.new(args) }.to raise_error(OptionParser::InvalidOption) 
  end

  it "should set the directory attribute to '/etc/varanus' if it's not passed as an option" do
    c = Varanus::ConfigManager.new
    c.directory.should == '/etc/varanus'
  end

  it "should set the directory attribute to whaetever is passed as an option" do
    args = ["--config-dir", "boo"]
    c = Varanus::ConfigManager.new args
    c.directory.should == 'boo'
  end
end


