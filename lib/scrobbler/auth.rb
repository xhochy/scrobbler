module Scrobbler
  # @todo everything
  class Auth < Base
  
    def initialize(username)
      @username = username
    end
    
    def token
        doc = Base.request(:token, :signed => true)
        token = ''
        doc.root.children.each do |child|
            next unless child.name == 'token'
            token = child.content
        end
        token
    end
    
  end
end

