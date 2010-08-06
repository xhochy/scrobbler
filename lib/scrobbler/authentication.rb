require 'cgi'
require 'digest/md5'

module Scrobbler
  class Authentication < Base

    def initialize(data = {})
      populate_data(data)
      super()
      
      @digest = Digest::MD5.new
      
      # Check if the input parameters are valid
      if @username.nil? || @username.empty?
        raise ArgumentError, 'Username is required'
      end
    end

    def auth_token(password)
      @digest.hexdigest(@username + @digest.hexdigest(password))
    end
      
    def mobile_session(password)
      xml = Base.request('auth.getMobileSession', {:username => @username, :signed => true, :authToken => auth_token(password)})
      load_session_out_of_session_request(xml)
    end
    
    def session(tokenStr)
      xml = Base.request('auth.getSession', {:signed => true, :token => tokenStr})
      load_session_out_of_session_request(xml)
    end
    
    def load_session_out_of_session_request(xml)
      # Find the session node
      xml.root.children.each do |child|
          next unless child.name == 'session'
          return Session.new(:xml => child)
      end
    end
    
    def token
      xml = Base.request('auth.getToken', {:signed => true})
      # Grep the token
      xml.root.children.each do |child|
          next unless child.name == 'token'
          return child.content
      end
    end
    
    def webservice_session_url(callback=nil)
      if not callback.nil? then
        cb = "&cb=" + CGI::escape(callback)
      else
        cb = ''
      end
      'http://www.last.fm/api/auth/?api_key=' + @@api_key + cb 
    end
    
    def desktop_session_url(tokenStr)
      webservice_session_url + '&token=' + tokenStr 
    end
  end
end