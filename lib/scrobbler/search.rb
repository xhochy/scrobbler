#
# This is an interface to the Last.FM Search API.
# It currently allows you to search by album, artist, or track.
#

module Scrobbler
  class Search < Base
    attr_accessor :type, :query

    def self.by_album(album_name)
      search = self.new
      search.type = 'album'
      search.query = album_name
      return search
    end

    def api_path
      "/#{API_VERSION}/?method=#{type}.search&album=#{CGI::escape(query)}&api_key="
    end

  end
end