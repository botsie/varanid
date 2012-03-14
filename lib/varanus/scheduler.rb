require 'rufus/scheduler'

module Varanus
  # Understands how to execute checks on a schedule
  class Scheduler
    attr_accessor :engine
    
    def initialize(config, zmq_context)
      @config = config
      @zmq_context = zmq_context
      self.engine = Rufus::Scheduler.start_new
      schedule_checks unless @config.nil?
    end

    def schedule_checks
      @config.checks.each do |check|
        job = Varanus::Job.new(check, @zmq_context)
        job.schedule_on self.engine
      end
    end
  end
end
