module Scrobbler
  # @todo everything
  class Radio < Base
    attr_reader :station
  
    def initialize(station)
      @station = station
    end

    def tune
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    def playlist
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    
  end
end

