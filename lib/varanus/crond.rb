require 'zmq'
require 'rufus/scheduler'

module Varanus
  class Crond
    def initialize(args)
    end
    def run
      context = ZMQ::Context.new(1)
      sender = context.socket(ZMQ::REQ)
      sender.connect('tcp://localhost:7777')
      100.times do |i|
        sender.send(i.to_s)
        data = sender.recv
        puts data
      end
    end
  end
end
