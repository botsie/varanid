
module Varanid
  # Understands 
  class Job
    def initialize(check, zmq_context)
      @check = check
      @zmq_context = zmq_context
    end

    def schedule_on engine
      engine.cron @check.crontab, self unless @check.crontab.nil?
      engine.every @check.interval, self unless @check.interval.nil?
    end

    def call
      # execute check
      @check.execute
      # transmit results
    end
  end
end
