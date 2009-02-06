#
# This is an interface to the Last.FM Search API.
# It currently allows you to search by album, artist, or track.
#

module Scrobbler
  class Search < Base
    attr_accessor :type, :query

    def execute
      doc = self.class.fetch_and_parse(api_path)
      albums = []
      (doc/"//album/url").each do |url|
        pieces = url.inner_html.split("/")
        artist_name = CGI.unescape(pieces[pieces.size - 2])
        album_name = CGI.unescape(pieces.last)
        albums << Album.new(artist_name, album_name)
      end
      albums
    end

    def self.by_album(album_name)
      search = self.new
      search.type = 'album'
      search.query = album_name
      return search
    end

    def api_path
      "/2.0/?method=#{type}.search&album=#{CGI::escape(query)}&api_key="
    end

  end
end