require 'zmq'
require 'rufus/scheduler'
require 'varanid/config'

module Varanid
  class SchedulerApp
    def initialize(args)
      @config = Varanid::Config.new(args)
      @zmq_context = ZMQ::Context.new(1)
    end
    def run
      @scheduler = Varanid::Scheduler.new(@config, @zmq_context)
      @scheduler.run
      # context = ZMQ::Context.new(1)
      # sender = context.socket(ZMQ::REQ)
      # sender.connect('tcp://localhost:7777')
      # 100.times do |i|
      #   sender.send(i.to_s)
      #   data = sender.recv
      #   puts data
      # end
    end
  end
end
