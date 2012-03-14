#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanus/config'
require 'varanus/scheduler'
require 'varanus/check'
require 'varanus/job'
require 'json'
require 'fileutils'
require 'rufus/scheduler'

require "spec_helper.rb"

module Varanus
  class Config
    def data=(value)
      @data = value
    end
  end
end


describe Varanus::Scheduler do
  it "should be instantiated with some params" do
    expect { s = Varanus::Scheduler.new(nil,nil) }.to_not raise_error
  end

  it "should have an instance of rufus_scheduler as it's engine by default" do
    s = Varanus::Scheduler.new(nil,nil)
    s.engine.should be_an_instance_of Rufus::Scheduler::PlainScheduler
  end

  it "should have one scheduled job if one 'every' check is configured" do
    config = check_every('5m')

    s = Varanus::Scheduler.new(config,nil)
    s.engine.all_jobs.count.should == 1
  end

  it "should have one scheduled job if one 'cron' check is configured" do
    config = check_cron('5 * * * *')

    s = Varanus::Scheduler.new(config,nil)
    s.engine.all_jobs.count.should == 1
  end
end

def check_every(interval)
  config = {
    :check => [
                Varanus::Check.new({ :every => interval})
               ]
  }
  c = Varanus::Config.new
  c.data = config
  return c 
end

def check_cron(crontab)
  config = {
    :check => [
                Varanus::Check.new({ :crontab => crontab})
               ]
  }
  c = Varanus::Config.new
  c.data = config
  return c 
end
