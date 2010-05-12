# encoding: utf-8

require File.expand_path('basexml.rb', File.dirname(__FILE__))

module Scrobbler
  class Tag < BaseXml
    include Scrobbler::StreamableObjectFuncs

    attr_reader :name, :count, :url, :streamable
    
    # Alias for Artist.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Tag.new(:xml => xml)
    end
    
    # Create a new Scrobbler::Artist instance
    #
    # @param [Hash] data The options to initialize the class
    def initialize(data = {})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      # Load data given as method-parameter
      populate_data(data)
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
          when 'count'
            @count = child.content.to_i
          when 'url'
            @url = child.content
          when 'name'
            @name = child.content
          when 'streamable'
            check_streamable_node(child)
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|
    end #^ load_from_xml

    def top_artists
      call('tag.gettopartists', :topartists, Artist, {:tag => @name})
    end
    
    def top_albums
      call('tag.gettopalbums', :topalbums, Album, {:tag => @name})
    end

    def top_tracks
      call('tag.gettoptracks', :toptracks, Track, {:tag => @name})
    end

    def self.top_tags
        Base.get('tag.gettoptags', :toptags, Tag)
    end
    
    def self.search
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    
    # Search for tags similar to this one. Returns tags ranked by similarity, 
    # based on listening data.
    def similar
        call('tag.getsimilar', :similartags, Tag, {:tag => @name})
    end

    def weekly_artist_chart
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def weekly_chart_list
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

  end
end
