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
      results = []
      if type == 'album'
        (doc/"//album").each do |album|
          artist = album/"artist"
          name = album/"name"
          results << Album.new(name.inner_html, :include_info => true, :artist => artist.inner_html)
        end
      elsif type == 'artist'
        (doc/"//artist/name").each do |name|
          results << Artist.new(name.inner_html)
        end
      elsif type == 'track'
        (doc/"//track").each do |track|
          artist = track/"artist"
          name = track/"name"
          results << Track.new(artist.inner_html, name.inner_html)
        end
      end
      results
    end

    def by_album(album_name)
      @type = 'album'
      @query = album_name
      execute
    end

    def by_artist(artist_name)
      @type = 'artist'
      @query = artist_name
      execute
    end

    def by_track(track_name)
      @type = 'track'
      @query = track_name
      execute
    end

    def api_path
      "/2.0/?method=#{type}.search&#{type}=#{CGI::escape(query)}&api_key=#{api_key}"
    end

  end
end
