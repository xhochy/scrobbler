# encoding: utf-8

require File.expand_path('base.rb', File.dirname(__FILE__))

module Scrobbler
  class BaseXml < Base
    # Load data out of a XML node
    def initialize(data = {})
      raise ArgumentError unless data.kind_of?(Hash)
      super()
      unless data[:xml].nil?
        load_from_xml(data[:xml])
        data.delete(:xml)
      end
      populate_data(data)
    end
  end
end