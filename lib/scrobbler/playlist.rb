module Scrobbler
  # @todo everything
  class Playlist < Base
    attr_reader :url
  
    def initialize(url)
      @url = url
    end
    
  end
end

