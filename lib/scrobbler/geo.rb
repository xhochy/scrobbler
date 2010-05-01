module Scrobbler
  class Geo < Base

    # Gets a list of events based on the location that
    # the Geo object is set to
    def events(options={})
      call('geo.getevents', :events, Event, options)
    end

    def top_artists(options={})
      call('geo.gettopartists', :topartists, Artist, options)
    end

    def top_tracks(options={})
      call('geo.gettoptracks', :toptracks, Track, options)
    end

  end
end