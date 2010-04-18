# encoding: utf-8

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
        options = {:force => false, :all => true}.merge options
        options[:user] = @user.name
        albums = []
        if options[:all]
            doc = Base.request('library.getalbums', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'albums'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'album'
                albums << Scrobbler::Album.new_from_libxml(child)
            end
            (2..total_pages).each do |i|
                options[:page] = i
                albums.concat get_response('library.getalbums', :none, 'albums', 'album', options, true)
            end
        else
            albums = get_response('library.getalbums', :get_albums, 'albums', 'album', options, true)
        end
        albums
    end

    # A list of all the artists in a user's library, with play counts and tag
    # counts. 
    #
    # @param [Hash<Symbol>] options The options to configure this API call.
    # @return [Array<Scrobbler::Artist>] The artists included in this library.
    def artists(options={})
        raise ArgumentError unless options.kind_of?(Hash)
        options = {:all => true}.merge options
        options[:user] = @user.name

        artists = []
        if options[:all]
            doc = request('library.getartists', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'artists'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'artist'
                artists << Scrobbler::Artist.new(:xml => child)
            end
            (2..total_pages).each do |i|
                options[:page] = i
                artists.concat call('library.getartists', 'artists', 'artist', options)
            end
        else
            artists = call('library.getartists', 'artists', 'artist', options)
        end
        artists
    end
    
    # A list of all the tracks in a user's library, with play counts and tag
    # counts. 
    def tracks(options={})
        options = {:force => false, :all => true}.merge options
        options[:user] = @user.name
        tracks = []
        if options[:all]
            doc = Base.request('library.gettracks', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'tracks'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'track'
                tracks << Scrobbler::Track.new_from_libxml(child)
            end
            (2..total_pages).each do |i|
                options[:page] = i
                tracks.concat get_response('library.gettracks', :none, 'tracks', 'track', options, true)
            end
        else
            tracks = get_response('library.gettracks', :get_albums, 'tracks', 'track', options, true)
        end
        tracks
    end
    
  end
end

