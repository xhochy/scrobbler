# encoding: utf-8

require File.expand_path('basexmlinfo.rb', File.dirname(__FILE__))

module Scrobbler
  class Playlist < BaseXmlInfo
    # Load Helper modules
    include ImageObjectFuncs
    include Scrobbler::StreamableObjectFuncs
    
    attr_reader :url, :id, :title, :date, :creator
    attr_reader :description, :size, :duration, :streamable
    
    # Alias for Playlist.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Playlist.new(:xml => xml)
    end

    def self.create
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def initialize(data={})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      raise ArgumentError, "Url is required" if @url.empty?
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
            @title = child.content
          when 'image'
            check_image_node(child)
          when 'date'
            @date = Time.parse(child.content)
          when 'streamable'
            check_streamable_node(child)
          when 'size'
            @size = child.content.to_i
          when 'description'
            @description = child.content
          when 'duration'
            @duration = child.content.to_i
          when 'creator'
            @creator = child.content
          when 'url'
            @url = child.content
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|
    end
    
    def add_track
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def fetch
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

  end
end

