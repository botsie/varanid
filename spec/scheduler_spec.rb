#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanid/config'
require 'varanid/scheduler'
require 'varanid/check'

require 'json'
require 'fileutils'
require 'rufus/scheduler'

require "spec_helper.rb"

module Varanid
  class Config
    def data=(value)
      @data = value
    end
  end
end


describe Varanid::Scheduler do
  it "should be instantiated with some params" do
    expect { s = Varanid::Scheduler.new(nil,nil) }.to_not raise_error
  end

  it "should have an instance of rufus_scheduler as it's engine by default" do
    s = Varanid::Scheduler.new(nil,nil)
    s.engine.should be_an_instance_of Rufus::Scheduler::PlainScheduler
  end

  it "should have one scheduled job if one 'every' check is configured" do
    config = check_every('5m')

    s = Varanid::Scheduler.new(config,nil)
    s.engine.all_jobs.count.should == 1
  end

  it "should have one scheduled job if one 'cron' check is configured" do
    config = check_cron('5 * * * *')

    s = Varanid::Scheduler.new(config,nil)
    s.engine.all_jobs.count.should == 1
  end
end

def check_every(interval)
  config = {
    :check => [
                Varanid::Check.new({ :every => interval})
               ]
  }
  c = Varanid::Config.new
  c.data = config
  return c 
end

def check_cron(crontab)
  config = {
    :check => [
                Varanid::Check.new({ :crontab => crontab})
               ]
  }
  c = Varanid::Config.new
  c.data = config
  return c 
end
