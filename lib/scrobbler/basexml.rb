# encoding: utf-8

require File.expand_path('base.rb', File.dirname(__FILE__))

module Scrobbler
  class BaseXml < Base
    # Load data out of a XML node
    def initialize(data = {})
      super()
      raise ArgumentError unless data.kind_of?(Hash)
      unless data[:xml].nil?
        load_from_xml(data[:xml])
        data.delete(:xml)
      end
    end
  end
end