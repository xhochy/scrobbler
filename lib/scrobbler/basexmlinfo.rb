# encoding: utf-8

require File.expand_path('basexml.rb', File.dirname(__FILE__))

module Scrobbler
  class BaseXmlInfo < BaseXml
    # Load data out of a XML node, fetch addtional info if requested
    #
    # @param [Hash] data
    def initialize(data = {})
      raise ArgumentError unless data.kind_of?(Hash)
      data = {:include_info => false}.merge(data)
      fetch_info = data.delete(:include_info) 
      super(data)
      load_info() if fetch_info 
    end
  end
end