# Getting information about an album such as release date and the tracks on it is very easy.
# 
#   album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts', :include_info => true)
# 
#   puts "Album: #{album.name}"
#   puts "Artist: #{album.artist}"
#   puts "Reach: #{album.reach}"
#   puts "URL: #{album.url}"
#   puts "Release Date: #{album.release_date.strftime('%m/%d/%Y')}"
# 
#   puts
#   puts
# 
#   puts "Tracks"
#   longest_track_name = album.tracks.collect(&:name).sort { |x, y| y.length <=> x.length }.first.length
#   puts "=" * longest_track_name
#   album.tracks.each { |t| puts t.name }
#
# Would output:
#
#   Album: Some Hearts
#   Artist: Carrie Underwood
#   Reach: 18729
#   URL: http://www.last.fm/music/Carrie+Underwood/Some+Hearts
#   Release Date: 11/15/2005
# 
# 
#   Tracks
#   ===============================
#   Wasted
#   Don't Forget to Remember Me
#   Some Hearts
#   Jesus, Take the Wheel
#   The Night Before (Life Goes On)
#   Lessons Learned
#   Before He Cheats
#   Starts With Goodbye
#   I Just Can't Live a Lie
#   We're Young and Beautiful
#   That's Where It Is
#   Whenever You Remember
#   I Ain't in Checotah Anymore
#   Inside Your Heaven
#
module Scrobbler
  # @todo Add missing functions that require authentication
  # @todo Integrate search functionality into this class which is already implemented in Scrobbler::Search
  class Album < Base
    attr_accessor :artist, :artist_mbid, :name, :mbid, :playcount, :rank, :url
    attr_accessor :reach, :release_date, :listeners, :playcount, :top_tags
    attr_accessor :image_large, :image_medium, :image_small
    attr_writer :tracks
    
    # needed on top albums for tag
    attr_accessor :count, :streamable
    
    # needed for weekly album charts
    attr_accessor :chartposition
    
    class << self
      def find(artist, name, o={})
        new(artist, name, o)
      end
      
      def new_from_xml(xml, doc=nil)
        name = Base::sanitize(xml.at(:name).inner_html) if xml.at(:name)
        name = Base::sanitize(xml['name'])              if name.nil? && xml['name']
        artist = Base::sanitize(xml.at('/artist/name').inner_html) if xml.at('/artist/name')
        a = Album.new(artist, name)
        a.artist_mbid = xml.at(:artist).at(:mbid).inner_html if xml.at(:artist) && xml.at(:artist).at(:mbid)
        a.mbid          = xml.at(:mbid).inner_html           if xml.at(:mbid)
        a.playcount     = xml.at(:playcount).inner_html      if xml.at(:playcount)
        a.chartposition = xml.at(:chartposition).inner_html  if xml.at(:chartposition)
        a.rank          = xml['rank']                        if xml['rank']
        a.url           = xml.at('/url').inner_html          if xml.at('/url')
        a.image_large   = xml.at("/image[@size='large']").inner_html  if xml.at("/image[@size='large']")
        a.image_medium  = xml.at("/image[@size='medium']").inner_html if xml.at("/image[@size='medium']")
        a.image_small   = xml.at("/image[@size='small']").inner_html  if xml.at("/image[@size='small']")
                
        # needed on top albums for tag
        a.count          = xml['count'] if xml['count']
        a.streamable     = xml['streamable'] if xml['streamable']
        a
      end
    end
    
    # If the additional parameter :include_info is set to true, additional 
    # information is loaded
    #
    # @todo Albums should be able to be created via a MusicBrainz id too
    def initialize(artist, name, o={})
      raise ArgumentError, "Artist is required" if artist.blank?
      raise ArgumentError, "Name is required" if name.blank?
      @artist = artist
      @name   = name
      options = {:include_info => false}.merge(o)
      load_info() if options[:include_info]
    end
    
    @info_loaded = false # Indicates if the info was already loaded
    
    # Load additional information about this album
    #
    # Calls "album.getinfo" REST method
    #
    # @todo Parse wiki content
    # @todo Add language code for wiki translation
    def load_info
      xml = request('album.getinfo', {'artist' => @artist, 'name' => @name})
      unless xml.at(:lfm)['status'] == 'failed' || @info_loaded
        xml = xml.at(:album)
        @url          = xml.at(:url).inner_html
        @release_date = Time.parse(xml.at(:releasedate).inner_html.strip)
        @image_extralarge = xml.at("/image[@size='extralarge']").inner_html
        @image_large  = xml.at("/image[@size='large']").inner_html
        @image_medium = xml.at("/image[@size='medium']").inner_html
        @image_small  = xml.at("/image[@size='small']").inner_html
        @mbid         = xml.at(:mbid).inner_html
        @listeners    = xml.at(:listeners).inner_html.to_i
        @playcount    = xml.at(:playcount).inner_html.to_i
        @info_loaded  = true
        @top_tags = []
        xml.at(:toptags).search(:tag).each do |elem|
            @top_tags << Tag.new_from_xml(elem)
        end
      end
    end
    
    def image(which=:small)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large', 'extralarge'].include?(which)      
      img_url = instance_variable_get("@image_#{which}")
      if img_url.nil?
        load_info
        img_url = instance_variable_get("@image_#{which}")
      end
      img_url
    end
  end
end
