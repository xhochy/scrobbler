# encoding: utf-8

require File.expand_path('basexmlinfo.rb', File.dirname(__FILE__))

module Scrobbler
  class Event < BaseXmlInfo
    # Load Helper modules
    include ImageObjectFuncs
    
    attr_reader :id, :title, :start_date, :start_time, :description
    attr_reader :reviews, :tag, :url, :artists, :headliner
    attr_reader :attendance, :venue, :website, :end_date
    
    # Alias for Event.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Event.new(:xml => xml)
    end

    # Create a new Scrobbler::Event instance
    #
    # @param [Hash] data The options to initialize the class
    def initialize(data = {})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      
      raise ArgumentError, "ID is required" if @id.nil?
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [LibXML::XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name.to_s
          when 'id'
            @id = child.content.to_i
          when 'title'
            @title = child.content.to_s
          when 'artists'
            @artists = [] if @artists.nil?
            child.children.each do |artist|
              @artists << Artist.new(:name => artist.content) if artist.name == 'artist'
              @headliner = Artist.new(:name => artist.content) if artist.name == 'headliner'
            end
            @artists << @headliner unless @headliner.nil? || headliner_alrady_listed_in_artist_list?
          when 'image'
            check_image_node(child)
          when 'url'
            @url = child.content
          when 'description'
            @description = child.content
          when 'attendance'
            @attendance = child.content.to_i
          when 'reviews'
            @reviews = child.content.to_i
          when 'tag'
            @tag = child.content
          when 'startDate'
            @start_date = Time.parse(child.content)
          when 'startTime'
            @start_time = child.content
          when 'endDate'
            @end_date = Time.parse(child.content)
          when 'tickets'
            # @todo Handle tickets
          when 'venue'
            @venue = Venue.new_from_xml(child)
          when 'website'
            @website = child.content.to_s
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|
      @artists.uniq!
    end #^ load_from_xml
    
    def headliner_alrady_listed_in_artist_list?
      @artists.each do |artist|
        return true if artist.name == @headliner.name
      end
      false
    end

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
      xml = Base.request('event.getinfo', {:event => @id})
      unless xml.root['status'] == 'failed'
        xml.root.children.each do |childL1|
          next unless childL1.name == 'event'
          load_from_xml(childL1)
        end # xml.children.each do |childL1|
        @info_loaded  = true
      end
    end

    def shouts
      call('event.getshouts', :shouts, Shout, {:event => @id})
    end

    def attendees
      call('event.getattendees', :attendees, User, {:event  => @id})
    end

    def shout
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def attend(session, attendance_status)
      Base.post_request('event.attend',{:event => @id, :signed => true, :status => attendance_status, :sk => session.key})
    end

    def share
      # This function requires authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

  end
end
