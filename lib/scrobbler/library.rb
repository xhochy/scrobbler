# encoding: utf-8

require File.expand_path('base.rb', File.dirname(__FILE__))

module Scrobbler
  # Class for invocation of library.* API functions.
  class Library < Base
    attr_reader :user
  
    # Create a new Scrobber::Library instance.
    #
    # @param [String, Symbol, Scrobbler::User] user The user who's library data
    #   is requested.
    # @raise ArgumentError If a not supported type is given as user.
    def initialize(user)
      super()
      if user.kind_of?(Scrobbler::User)
        @user = user
      elsif user.kind_of?(String)
        @user = Scrobbler::User.new(:name => user.to_s)
      else
        raise ArgumentError, "Invalid argument for user: #{user.class}"
      end
    end
    
    def add_album
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    def add_artist
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    def add_track
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
    # A list of all the albums in a user's library, with play counts and tag 
    # counts. 
    # @param [Hash<Symbol>] options The options to configure this API call.
    # @return [Array<Scrobbler::Tracks>] The artists included in this library.
    def albums(options={})
      call_pageable('library.getalbums', :albums, Album, {:user => @user.name}.merge(options))
    end

    # A list of all the artists in a user's library, with play counts and tag
    # counts. 
    #
    # @param [Hash<Symbol>] options The options to configure this API call.
    # @return [Array<Scrobbler::Artist>] The artists included in this library.
    def artists(options={})
      call_pageable('library.getartists', :artists, Artist, {:user => @user.name}.merge(options))
    end
    
    # A list of all the tracks in a user's library, with play counts and tag
    # counts. 
    # @param [Hash<Symbol>] options The options to configure this API call.
    # @return [Array<Scrobbler::Track>] The tracks included in this library.
    def tracks(options={})
      call_pageable('library.gettracks', :tracks, Track, {:user => @user.name}.merge(options))
    end
    
    
  end
end

