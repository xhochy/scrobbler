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
        @user = Scrobbler::User.new(user.to_s)
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
    def albums(options={})
      request_library('library.getalbums', :albums, Album, options)
    end

    # A list of all the artists in a user's library, with play counts and tag
    # counts. 
    #
    # @param [Hash<Symbol>] options The options to configure this API call.
    # @return [Array<Scrobbler::Artist>] The artists included in this library.
    def artists(options={})
      request_library('library.getartists', :artists, Artist, options)
    end
    
    # A list of all the tracks in a user's library, with play counts and tag
    # counts. 
    def tracks(options={})
        request_library('library.gettracks', :tracks, Track, options)
    end
    
    # Generic request method for the most Library funtions
    #
    # @param [String,Symbol] api_method The method which shall be called.
    # @param [Hash] options The parameters passed as URL params.
    # @param [String,Symbol] parent the parent XML node to look for.
    # @param [Class] element The xml node name which shall be converted
    #   into an object.
    # @return [Array]
    def request_library(method, parent, element, options={})
      options = {:all => true, :user => @user.name}.merge options
      result = []
      if options.delete(:all)
        doc = Base.request(method, options)
        root = nil
        doc.root.children.each do |child|
          next unless child.name == parent.to_s
          root = child
        end
        total_pages = root['totalPages'].to_i
        root.children.each do |child|
          next unless child.name == element.to_s.sub("Scrobbler::","").downcase
          result << element.new_from_libxml(child)
        end
        (2..total_pages).each do |i|
          options[:page] = i
          result.concat call(method, parent, element, options)
        end
      else
        result = call(method, parent, element, options)
      end
      result
    end
    
  end
end

