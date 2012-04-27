
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
  end
end
