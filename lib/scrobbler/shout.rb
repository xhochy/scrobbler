# encoding: utf-8

require File.expand_path('basexml.rb', File.dirname(__FILE__))

module Scrobbler
  class Shout < BaseXml
    attr_reader :author, :date, :body

    # Alias for Shout.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      Shout.new(:xml => xml)
    end

    def initialize(data={})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      # Load data given as method-parameter
      populate_data(data)
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [LibXML::XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name
          when 'body'
            @body = child.content
          when 'author' 
            @author = Scrobbler::User.new(:name => child.content)
          when 'date'
            @date = Time.parse(child.content)
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
