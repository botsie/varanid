module Varanus
  # Understands how to schedule checks for execution
  class Scheduler
    attr_accessor :scheduler
    
    def initialize(config, zmq_context)
      @config = config
      @zmq_context = zmq_context
    end
  end
end
