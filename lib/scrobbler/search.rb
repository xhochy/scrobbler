#
# This is an interface to the Last.FM Search API.
# It currently allows you to search by album, artist, or track.
#

module Scrobbler
  class Search < Base
    attr_accessor :type, :query, :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def execute
      doc = self.class.fetch_and_parse(api_path)
      puts doc
      albums = []
      (doc/"//album/url").each do |url|
        pieces = url.inner_html.split("/")
        artist_name = CGI.unescape(pieces[pieces.size - 2])
        album_name = CGI.unescape(pieces.last)
        albums << Album.new(artist_name, album_name)
      end
      albums
    end

    def by_album(album_name)
      @type = 'album'
      @query = album_name
      execute
    end

    def api_path
      "/2.0/?method=#{type}.search&album=#{CGI::escape(query)}&api_key=#{api_key}"
    end

  end
end