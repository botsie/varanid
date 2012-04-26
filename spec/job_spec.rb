#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanus/job'
require 'varanus/check'
require 'json'
require 'fileutils'

require "spec_helper.rb"

describe Varanus::Job do
  it "should be instantiated with some params" do
    expect { s = Varanus::Job.new(nil, nil) }.to_not raise_error
  end

  it "should schedule an every job if the check specifies it" do
    check = Varanus::Check.new({ :every => '5m' })
    j = Varanus::Job.new(check, nil)
    scheduler_engine = double("rufus_scheduler")

    scheduler_engine.should_receive(:every).with('5m', j)

    j.schedule_on scheduler_engine
  end

  it "should schedule a cron job if the check specifies it" do
    check = Varanus::Check.new({ :crontab => '5 * * * *' })
    j = Varanus::Job.new(check, nil)
    scheduler_engine = double("rufus_scheduler")

    scheduler_engine.should_receive(:cron).with('5 * * * *', j) 

    j.schedule_on scheduler_engine 
  end

  it "should execute the check when called" do    
    check = double("varanus_check")
    j = Varanus::Job.new(check, nil)

    check.should_receive(:execute)

    j.call
  end
end

