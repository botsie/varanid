
module Varanid
  class Check
    def initialize(config)
      @config = config
    end

    def interval
      @config[:every]
    end

    def crontab
      @config[:crontab]
    end

    def schedule_on engine
      engine.cron crontab, self unless crontab.nil?
      engine.every interval, self unless interval.nil?
    end

    def call
    end
  end
end
