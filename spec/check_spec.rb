#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanid/check'
require 'json'
require 'fileutils'

require "spec_helper.rb"

describe Varanid::Check do
  it "should be instantiated with some params" do
    expect { s = Varanid::Check.new(nil) }.to_not raise_error
  end

  it "should expose the value of the interval property" do
    s = Varanid::Check.new( { :every => '5m' } )
    s.interval.should == '5m'
  end

  it "should expose the value of the crontab property" do
    s = Varanid::Check.new( { :crontab => '5 * * * *' } )
    s.crontab.should == '5 * * * *'
  end
end

