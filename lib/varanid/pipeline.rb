require 'zmq'

module Varanid
  class Pipeline
    def initialize(args)
    end
    def run
      context = ZMQ::Context.new(1)
      listener = context.socket(ZMQ::REP)
      listener.bind('tcp://127.0.0.1:7777')
      loop do
        data = listener.recv
        puts data
        listener.send('ack')
      end
    end
  end
end
