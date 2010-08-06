# encoding: utf-8

require File.expand_path('basexml.rb', File.dirname(__FILE__))

module Scrobbler
  class Session < BaseXml
    attr_reader :key, :name, :subscriber
    
    def initialize(data={})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [LibXML::XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name
          when 'name'
            @name = child.content
          when 'key' 
            @key = child.content
          when 'subscriber'
            if child.content == '1' then
              @subscriber = true
            else
              @subscriber = false
            end
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|
    end #^ load_from_xml
  end
end
