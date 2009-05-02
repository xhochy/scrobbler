# Below are examples of how to find an artists top tracks and similar artists.
# 
#   artist = Scrobbler::Artist.new('Carrie Underwood')
# 
#   puts 'Top Tracks'
#   puts "=" * 10
#   artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
# 
#   puts
# 
#   puts 'Similar Artists'
#   puts "=" * 15
#   artist.similar.each { |a| puts "(#{a.match}%) #{a.name}" }
# 
# Would output something similar to:
# 
#   Top Tracks
#   ==========
#   (8797) Before He Cheats
#   (3574) Don't Forget to Remember Me
#   (3569) Wasted
#   (3246) Some Hearts
#   (3142) Jesus, Take the Wheel
#   (2600) Starts With Goodbye
#   (2511) Jesus Take The Wheel
#   (2423) Inside Your Heaven
#   (2328) Lessons Learned
#   (2040) I Just Can't Live a Lie
#   (1899) Whenever You Remember
#   (1882) We're Young and Beautiful
#   (1854) That's Where It Is
#   (1786) I Ain't in Checotah Anymore
#   (1596) The Night Before (Life Goes On)
#   
#   Similar Artists
#   ===============
#   (100%) Rascal Flatts
#   (84.985%) Keith Urban
#   (84.007%) Kellie Pickler
#   (82.694%) Katharine McPhee
#   (81.213%) Martina McBride
#   (79.397%) Faith Hill
#   (77.121%) Tim McGraw
#   (75.191%) Jessica Simpson
#   (75.182%) Sara Evans
#   (75.144%) The Wreckers
#   (73.034%) Kenny Chesney
#   (71.765%) Dixie Chicks
#   (71.084%) Kelly Clarkson
#   (69.535%) Miranda Lambert
#   (66.952%) LeAnn Rimes
#   (66.398%) Mandy Moore
#   (65.817%) Bo Bice
#   (65.279%) Diana DeGarmo
#   (65.115%) Gretchen Wilson
#   (62.982%) Clay Aiken
#   (62.436%) Ashlee Simpson
#   (62.160%) Christina Aguilera
module Scrobbler
  # @todo Add missing functions that require authentication
  # @todo Integrate search functionality into this class which is already implemented in Scrobbler::Search
  class Artist < Base
    attr_accessor :name, :mbid, :playcount, :rank, :url, :count, :streamable
    attr_accessor :chartposition, :image_small, :image_medium, :image_large
    
    # used for similar artists
    attr_accessor :match
    
    class << self
      def new_from_libxml(xml)
        # Step 1 get all information from the root's attributes
        name = xml['name'] if xml['name']
        rank = xml['rank'] if xml['rank']
        streamable = xml['streamable'] if xml['streamable']
        
        # Step 2 get all information from the root's children nodes
        data = {}
        xml.children.each do |child|
          if child.name == 'name' && name.nil?
            name = child.content
          elsif child.name == 'mbid'
            data[:mbid] = child.content
          elsif child.name == 'playcount'
            data[:playcount] = child.content
          elsif child.name == 'url'
            data[:url] = child.content
          elsif child.name == 'image'
            if child['size'] == 'small'
              data[:image_small] = child.content
            elsif child['size'] == 'medium'
              data[:image_medium] = child.content
            elsif child['size'] == 'large'
              data[:image_large] = child.content
            end
          elsif child.name == 'match'
            data[:match] = child.content
          elsif child.name == 'chartposition'
            data[:chartposition] = child.content
          elsif child.name == 'streamable'
            data[:streamable] = child.content
          end
        end
        
        # Step 3 fill the object
        Artist.new(name, data)
      end
      
      def new_from_xml(xml, doc=nil)
        # occasionally name can be found in root of artist element (<artist name="">) rather than as an element (<name>)
        name             = Base::sanitize(xml['name'])          if xml['name']
        name         = Base::sanitize(xml.at('/name').inner_html) if name.nil? && (xml).at(:name)
        a                = Artist.new(name)
        a.mbid           = xml.at(:mbid).inner_html           if xml.at(:mbid)
        a.playcount      = xml.at(:playcount).inner_html      if xml.at(:playcount)
        a.rank           = Base::sanitize(xml['rank'])           if xml['rank']
        a.url            = xml.at(:url).inner_html            if xml.at(:url)
        a.image_small  = xml.at("image[@size='small']").inner_html   if xml.at("image[@size='small']")
        a.image_medium = xml.at("image[@size='medium']'").inner_html if xml.at("image[@size='medium']'")
        a.image_large  = xml.at("image[@size='large']'").inner_html  if xml.at("image[@size='large']'")
        a.match          = xml.at(:match).inner_html          if xml.at(:match)
        a.chartposition = xml.at(:chartposition).inner_html  if xml.at(:chartposition)

        # in top artists for tag
        a.count          = xml.at('/tagcount').inner_html    if xml.at('/tagcount')
        a.streamable     = xml['streamable']                    if xml['streamable']
        a.streamable     = xml.at(:streamable).inner_html == '1' ? 'yes' : 'no' if a.streamable.nil? && xml.at(:streamable)
        a
      end
    end
    
    def initialize(name, data = {})
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
      @rank = data[:rank] unless data[:rank].nil?
      @streamable = data[:streamable] unless data[:streamable].nil?
      @mbid = data[:mbid] unless data[:mbid].nil?
      @playcount = data[:playcount] unless data[:playcount].nil?
      @url = data[:url] unless data[:url].nil?
      @image_small = data[:image_small] unless data[:image_small].nil?
      @image_medium = data[:image_medium] unless data[:image_medium].nil?
      @image_large = data[:image_large] unless data[:image_large].nil?
      @match = data[:match] unless data[:match].nil?
      @chartposition = data[:chartposition] unless data[:chartposition].nil?
    end
    
    # Get the URL to the ical or rss representation of the current events that
    # a artist will play
    #
    # @todo Use the API function and parse that into a common ruby structure
    def current_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}/2.0/artist/#{CGI::escape(name)}/events.#{format}"
    end
    
    def image(which=:small)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large'].include?(which)      
      instance_variable_get("@image_#{which}")
    end
    
    def similar(force=false)
      if @similar.nil?
        doc = request('artist.getsimilar', {'artist' => @name}, false)
        # As XPath this would be /lfm/similarartists/artist
        @similar = []
        doc.root.children.each do |child|
          next unless child.name == 'similarartists'
          child.children.each do |artist|
            next unless artist.name == 'artist'
             @similar << Artist.new_from_libxml(artist)
          end
        end
      end
      @similar      
    end
    
    def top_fans(force=false)
      get_instance2('artist.gettopfans', :top_fans, :user, {'artist'=>@name}, force)
    end
    
    def top_tracks(force=false)
      get_instance2('artist.gettoptracks', :top_tracks, :track, {'artist'=>@name}, force)
    end
    
    def top_albums(force=false)
      get_instance2('artist.gettopalbums', :top_albums, :album, {'artist'=>@name}, force)
    end
    
    def top_tags(force=false)
      get_instance2('artist.gettoptags', :top_tags, :tag, {'artist'=>@name}, force)
    end
  end
end
