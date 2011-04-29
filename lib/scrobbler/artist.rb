# encoding: utf-8

require File.expand_path('basexmlinfo.rb', File.dirname(__FILE__))

module Scrobbler
  # @todo Add missing functions that require authentication
  # @todo Integrate search functionality into this class which is already implemented in Scrobbler::Search
  class Artist < BaseXmlInfo
    include Scrobbler::ImageObjectFuncs
    include Scrobbler::StreamableObjectFuncs
    
    attr_reader :name, :mbid, :playcount, :rank, :url, :count, :listeners
    attr_reader :chartposition, :streamable, :match, :tagcount, :bio
    
    # Alias for Artist.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Artist.new(:xml => xml)
    end

    # Create a new Scrobbler::Artist instance
    #
    # @param [Hash] data The options to initialize the class
    def initialize(data = {})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      raise ArgumentError, "Name is required" if @name.nil? || @name.strip.empty?
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name
          when 'playcount'
            @playcount = child.content.to_i
          when 'mbid'
            @mbid = child.content
          when 'url'
            @url = child.content
          when 'match'
            @match = child.content.to_i
          when 'tagcount'
            @tagcount = child.content.to_i
          when 'chartposition'
            @chartposition = child.content
          when 'name'
            @name = child.content
          when 'image'
            check_image_node(child)
          when 'streamable'
            check_streamable_node(child)
          when 'stats'
            child.children.each do |childL2|
              @listeners = childL2.content.to_i if childL2.name == 'listeners'
              @playcount = childL2.content.to_i if childL2.name == 'playcount'
              @playcount = childL2.content.to_i if childL2.name == 'plays'
            end if not child.children.nil?
          when 'similar'
            # Ignore them for the moment, they are not stored.
          when 'bio'
            child.children.each do |childL2|
              @bio = childL2.content if childL2.name == 'content'
            end
          when 'tags'
            # Ignore them at the moment, inlude them later
            # TODO Include a interface for these tags
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|

      # Get all information from the root's attributes
      @name = node['name'] unless node['name'].nil?
      @rank = node['rank'].to_i unless node['rank'].nil?
      maybe_streamable_attribute(node)
      @mbid = node['mbid'] unless node['mbid'].nil?

      # If we have not found anything in the content of this node yet then
      # this must be a simple artist node which has the name of the artist
      # as its content
      @name = node.content if @name.nil?
    end #^ load_from_xml
    
    # Get the URL to the ical or rss representation of the current events that
    # a artist will play
    #
    # @todo Use the API function and parse that into a common ruby structure
    # @return [String]
    def current_events(format=:ics)
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}/2.0/artist/#{CGI::escape(@name)}/events.#{format.to_s}"
    end
    
    # Get all the artists similar to this artist
    #
    # @return [Array<Scrobbler::Artist>]
    def similar
      call('artist.getsimilar', :similarartists, Artist, {:artist => @name})
    end

    # Get the top fans for an artist on Last.fm, based on listening data.
    #
    # @return [Array<Scrobbler::User>]
    def top_fans
      call('artist.gettopfans', :topfans, User, {:artist => @name})
    end
    
    # Get the top tracks by an artist on Last.fm, ordered by popularity
    #
    # @return [Array<Scrobbler:Track>]
    def top_tracks
      call('artist.gettoptracks', :toptracks, Track, {:artist => @name})
    end
    
    # Get the top albums for an artist on Last.fm, ordered by popularity.
    #
    # @return [Array<Scrobbler::Album>]
    def top_albums
      call('artist.gettopalbums', :topalbums, Album, {:artist => @name})
    end
    
    # Get the top tags for an artist on Last.fm, ordered by popularity.
    #
    # @return [Array<Scrobbler::Tags>]
    def top_tags
      call('artist.gettoptags', :toptags, Tag, {:artist => @name})
    end
    
    @info_loaded = false
    
    # Get the metadata for an artist on Last.fm. Includes biography.
    #
    # @return [nil]
    def load_info
     if @mbid.nil?
        req_args = {:artist => @name}
      else
        req_args = {:mbid => @mbid}
      end
      doc = request('artist.getinfo', req_args)
      doc.root.children.each do |childL1|
        next unless childL1.name == 'artist'
        load_from_xml(childL1)
      end if (not doc.root.nil?) && (not doc.root.children.nil?)
      @info_loaded = true
    end # load_info

    # Compare two Artists
    #
    # They are equal if their names are equal.
    #
    # @param [Scrobbler::Artist] other_artist
    # @return [Boolean]
    def ==(other_artist)
      if other_artist.is_a?(Scrobbler::Artist)
        return (@name == other_artist.name)
      end
      false
    end

    def search
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def share
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def shout
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def add_tags
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def events
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def images
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def shouts
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def tags
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def remove_tag
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
  end
end
