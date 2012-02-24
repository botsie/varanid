#!/usr/bin/env ruby

libdir = File.expand_path("../../lib", __FILE__)
$: << libdir unless $:.include? libdir

require 'varanus/check'
require 'json'
require 'fileutils'

require "spec_helper.rb"

describe Varanus::Check do
  it "should be instantiated with some params" do
    expect { s = Varanus::Check.new(nil) }.to_not raise_error
  end

end

