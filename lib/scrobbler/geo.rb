module Scrobbler
  class Geo < Base
    attr_accessor :location    

    class << self
      def new_from_libxml(xml)
        #        data = {}
        #
        #        # Step 1 get all information from the root's attributes
        #        data[:name] = xml['name'] if xml['name']
        #        data[:rank] = xml['rank'] if xml['rank']
        #        data[:streamable] = xml['streamable'] if xml['streamable']
        #
        #        # Step 2 get all information from the root's children nodes
        #        xml.children.each do |child|
        #          data[:playcount] = child.content if child.name == 'playcount'
        #          data[:mbid] = child.content if child.name == 'mbid'
        #          data[:url] = child.content if child.name == 'url'
        #          data[:match] = child.content if child.name == 'match'
        #          data[:chartposition] = child.content if child.name == 'chartposition'
        #          data[:streamable] = child.content if child.name == 'streamable'
        #          data[:name] = child.content if child.name == 'name'
        #
        #          if child.name == 'image'
        #            data[:image_small] = child.content if child['size'] == 'small'
        #            data[:image_medium] = child.content if child['size'] == 'medium'
        #            data[:image_large] = child.content if child['size'] == 'large'
        #          end
        #        end

        # Step 3 fill the object
        #Geo.new(data[:location], data)
      end

      def new_from_xml(xml, doc=nil)
        #        # occasionally name can be found in root of artist element (<artist name="">) rather than as an element (<name>)
        #        name             = Base::sanitize(xml['name'])          if xml['name']
        #        name         = Base::sanitize(xml.at('/name').inner_html) if name.nil? && (xml).at(:name)
        #        a                = Artist.new(name)
        #        a.mbid           = xml.at(:mbid).inner_html           if xml.at(:mbid)
        #        a.playcount      = xml.at(:playcount).inner_html      if xml.at(:playcount)
        #        a.rank           = Base::sanitize(xml['rank'])           if xml['rank']
        #        a.url            = xml.at(:url).inner_html            if xml.at(:url)
        #        a.image_small  = xml.at("image[@size='small']").inner_html   if xml.at("image[@size='small']")
        #        a.image_medium = xml.at("image[@size='medium']'").inner_html if xml.at("image[@size='medium']'")
        #        a.image_large  = xml.at("image[@size='large']'").inner_html  if xml.at("image[@size='large']'")
        #        a.match          = xml.at(:match).inner_html          if xml.at(:match)
        #        a.chartposition = xml.at(:chartposition).inner_html  if xml.at(:chartposition)
        #
        #        # in top artists for tag
        #        a.count          = xml.at('/tagcount').inner_html    if xml.at('/tagcount')
        #        a.streamable     = xml['streamable']                    if xml['streamable']
        #        a.streamable     = xml.at(:streamable).inner_html == '1' ? 'yes' : 'no' if a.streamable.nil? && xml.at(:streamable)
        #        a
      end
    end

    def initialize(location, data = {})
      raise ArgumentError, "Location is required" if location.blank?
      @location = location
      populate_data(data)
    end

    # Get the URL to the ical or rss representation of the current events that
    # a artist will play
    #
    # @todo Use the API function and parse that into a common ruby structure
    def events(force=false )
      #format = :ics if format.to_s == 'ical'
      #raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      #"#{API_URL.chop}/2.0/geo/#{CGI::escape(location)}/events.#{format}"
#      get_response('geo.getevents', :events, 'events', 'geo', {'location' => @location}, force)
      #get_instance2('artist.gettoptracks', :top_tracks, :track, {'artist'=>@name}, force)
      get_instance2('geo.getevents', :events, :event, {'location'=>@location}, force)
    end
    #
    #    def image(which=:small)
    #      which = which.to_s
    #      raise ArgumentError unless ['small', 'medium', 'large'].include?(which)
    #      instance_variable_get("@image_#{which}")
    #    end
    #
    #    def similar(force=false)
    #      get_response('artist.getsimilar', :similar, 'similarartists', 'artist', {'artist' => @name}, force)
    #    end
    #
    #    def top_fans(force=false)
    #      get_response('artist.gettopfans', :top_fans, 'topfans', 'user', {'artist' => @name}, force)
    #    end
    #
    #    def top_tracks(force=false)
    #      get_instance2('artist.gettoptracks', :top_tracks, :track, {'artist'=>@name}, force)
    #    end
    #
    #    def top_albums(force=false)
    #      get_instance2('artist.gettopalbums', :top_albums, :album, {'artist'=>@name}, force)
    #    end
    #
    #    def top_tags(force=false)
    #      get_response('artist.gettoptags', :top_tags, 'toptags', 'tag', {'artist' => @name}, force)
    #    end

  end
end
