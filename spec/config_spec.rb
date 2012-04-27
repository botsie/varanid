#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanid/config'
require 'varanid/check'
require 'json'
require 'fileutils'

require "spec_helper.rb"


describe Varanid::Config do
  it "can be instantiated" do
    expect { c = Varanid::Config.new() }.to_not raise_error
  end

  it "can be instantiated with an argument" do
    args = Array.new
    expect { c = Varanid::Config.new(args) }.to_not raise_error    
  end

  it "should only accept an array as an argument" do
    args = ""
    expect { c = Varanid::Config.new(args) }.to raise_error    
  end

  describe "Option Parsing" do
    it "should accept --config-dir argument" do
      args = ["--config-dir"]
      expect { c = Varanid::Config.new(args) }.to_not raise_error(OptionParser::InvalidOption) 
    end

    # suppress noise during test
    xit "should accept --help argument" do
      args = ["--help"]
      expect { c = Varanid::Config.new(args) }.to_not raise_error(OptionParser::InvalidOption)    
    end

    it "should not accept any other argument" do
      args = ["--foo"]
      expect { c = Varanid::Config.new(args) }.to raise_error(OptionParser::InvalidOption) 
    end

    it "should set the directory attribute to '/etc/varanid' if it's not passed as an option" do
      c = Varanid::Config.new
      c.directory.should == '/etc/varanid'
    end

    it "should set the directory attribute to whaetever is passed as an option" do
      args = ["--config-dir", "boo"]
      c = Varanid::Config.new args
      c.directory.should == 'boo'
    end
  end

  describe "Config File Parsing" do
    let(:test_data_dir) { File.expand_path("../test_data", __FILE__) }

    before(:each) do
      FileUtils.mkdir_p test_data_dir
    end
    
    after(:each) do
      FileUtils.rm_rf test_data_dir
    end
    
    it "should add a file in the the config dir to the config" do
      content = { 'foo' => 'bar' }
      create_file("foo.json", content.to_json)
      c = Varanid::Config.new ["-d", test_data_dir]
      c[:foo].should == 'bar'
    end

    it "should merge two values into an array" do
      content = { 'foo' => 'bar' }
      create_file("foo.json", content.to_json)
      content2 = { 'foo' => 'bar2' }
      create_file("foo2.json", content2.to_json)
      
      c = Varanid::Config.new ["-d", test_data_dir]
      c[:foo].should == [ 'bar', 'bar2' ]
    end

    it "should merge multiple values into an array" do
      content = { 'foo' => 'bar' }
      create_file("foo.json", content.to_json)
      content2 = { 'foo' => 'bar2' }
      create_file("foo2.json", content2.to_json)
      content3 = { 'foo' => 'bar3' }
      create_file("foo3.json", content3.to_json)
      
      c = Varanid::Config.new ["-d", test_data_dir]
      c[:foo].should == [ 'bar', 'bar2', 'bar3' ]
    end
    
    it "should merge multiple arrays into an array" do
      content = { 'foo' => [1, 2, 3] }
      create_file("foo.json", content.to_json)
      content2 = { 'foo' => [4, 5, 6] }
      create_file("foo2.json", content2.to_json)
      
      
      c = Varanid::Config.new ["-d", test_data_dir]
      c[:foo].should == [1, 2, 3, 4, 5, 6]
    end

    it "should convert a check into a check object" do
      content = {'check' => {'foo' => 'bar'}}
      create_file("foo.json", content.to_json)

      c = Varanid::Config.new ["-d", test_data_dir]
      c[:check].should be_an_instance_of Varanid::Check
    end
    
    it "should expose check objects via the checks mehod" do
      content = {'check' => {'foo' => 'bar'}}
      create_file("foo.json", content.to_json)

      c = Varanid::Config.new ["-d", test_data_dir]
      c.checks.should be_an_instance_of Array
      c.checks.first.should be_an_instance_of Varanid::Check
    end
    
    def create_file(name, content)
      file_path = File.join(test_data_dir, name)
      File.open(file_path, 'w') {|f| f.write(content) }
    end
  end
end

