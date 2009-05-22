#
# This is an interface to the Last.FM Search API.
# It currently allows you to search by album, artist, or track.
#
module Scrobbler
  class Shout < Base
    class << self
      def new_from_libxml(xml)
      end
    end
  end
end
