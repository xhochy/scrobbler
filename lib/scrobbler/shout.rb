#
# This is an interface to the Last.FM Search API.
# It currently allows you to search by album, artist, or track.
#
module Scrobbler
  class Shout < Base
    class << self
      def new_from_libxml(xml)
        data={}
        xml.children.each do |child|
          data[:body] = child.content if child.name == 'body'
          data[:author] = child.content if child.name == 'author'
          data[:date] = child.content if child.name == 'date'
        end
        Shout.new(data)
      end
    end

    def initialize(input={})
      populate_data(input)
    end
  end
end
