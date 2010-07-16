# encoding: utf-8

require File.expand_path('basexmlinfo.rb', File.dirname(__FILE__))

module Scrobbler
  # Class for handling album.* requests to the Last.fm API and reading Album data
  # provided in return.
  class Album < BaseXmlInfo
    include Scrobbler::ImageObjectFuncs
    
    attr_reader :artist, :artist_mbid, :name, :mbid, :playcount, :rank, :url
    attr_reader :reach, :release_date, :listeners, :playcount, :top_tags
    attr_reader :count, :chartposition, :position, :tagcount
    
    # Alias for Album.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Album.new(:xml => xml)
    end
      
    def search
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    # Create a new Scrobbler::Artist instance
    #
    # If the additional parameter :include_info is set to true, additional 
    # information is loaded
    #
    # @param [Hash] data The options to initialize the class
    def initialize(data={})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      
      raise ArgumentError, "Artist or mbid is required" if @artist.nil? && @mbid.nil?
      raise ArgumentError, "Name is required" if @name.empty?
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [LibXML::XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name.to_s
          when 'name'
            @name = child.content
          when 'title'
            @name = child.content
          when 'playcount'
            @playcount = child.content.to_i
          when 'tagcount'
            @tagcount = child.content.to_i
          when 'mbid'
            @mbid = child.content
          when 'url'
            @url = child.content
          when 'artist'
            @artist = Artist.new(:xml => child)
          when 'image'
            check_image_node(child)
          when 'id'
            @id = child.content.to_s
          when 'releasedate'
            @release_date = Time.parse(child.content.strip)
          when 'listeners'
            @listeners = child.content.to_i
          when 'toptags'
            @top_tags = [] if @top_tags.nil?
            child.children.each do |tag|
              next unless tag.name == 'tag'
              @top_tags << Tag.new_from_libxml(tag)
            end
          when 'wiki'
            # @todo Handle wiki entries
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|

      # Get all information from the root's attributes
      @mbid = node['mbid'].to_s unless node['mbid'].nil?
      @rank = node['rank'].to_i unless node['rank'].nil?
      @position = node['position'].to_i unless node['position'].nil?

      # If we have not found anything in the content of this node yet then
      # this must be a simple artist node which has the name of the artist
      # as its content
      @name = node.content if @name.nil?
    end #^ load_from_xml

    # Indicates if the info was already loaded
    @info_loaded = false 
    
    # Load additional information about this album
    #
    # Calls "album.getinfo" REST method
    #
    # @todo Parse wiki content
    # @todo Add language code for wiki translation
    def load_info
      return nil if @info_loaded
      xml = Base.request('album.getinfo', {:artist => @artist, :album => @name})
      unless xml.root['status'] == 'failed'
        xml.root.children.each do |childL1|
          next unless childL1.name == 'album'
          load_from_xml(childL1)
        end # xml.children.each do |childL1|
        @info_loaded  = true
      end
    end
    
    # Tag an album using a list of user supplied tags.
    #
    # @param [Scrobbler::Session] session A valid session to authenticate access
    # @param [Array<String>] tags Tags to add to this album
    # @return [nil] 
    def add_tags(session, tags)
      Base.post_request('album.addTags', {:sk => session.key, :signed => true, :tags => tags.join(',')})
    end

    # Get the tags applied by an individual user to an album on Last.fm.
    def tags()
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end

    # Remove a user's tag from an album.
    def remove_tag()
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
  end
end
