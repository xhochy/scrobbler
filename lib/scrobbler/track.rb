# encoding: utf-8

module Scrobbler
  class Track < Base
    # Load Helper modules
    include ImageObjectFuncs
    extend  ImageClassFuncs
    
    attr_reader :artist, :name, :mbid, :playcount, :rank, :url, :id, :count
    attr_reader :streamable, :album, :date, :now_playing, :tagcount
    attr_reader :duration, :listeners
    
    def self.new_from_libxml(xml)
      data = {}
      xml.children.each do |child|
        data[:name] = child.content if child.name == 'name'
        data[:mbid] = child.content if child.name == 'mbid'
        data[:url] = child.content if child.name == 'url'
        data[:date] = Time.parse(child.content) if child.name == 'date'
        data[:artist] = Artist.new(:xml => child) if child.name == 'artist'
        data[:album] = Album.new(:xml => child) if child.name == 'album'
        data[:playcount] = child.content.to_i if child.name == 'playcount'
        data[:tagcount] = child.content.to_i if child.name == 'tagcount'
        maybe_image_node(data, child)
        if child.name == 'streamable'
          if ['1', 'true'].include?(child.content)
            data[:streamable] = true
          else
            data[:streamable] = false
          end
        end
      end
      
      
      data[:rank] = xml['rank'].to_i if xml['rank']
      data[:now_playing] = true if xml['nowplaying'] && xml['nowplaying'] == 'true'
      
      data[:now_playing] = false if data[:now_playing].nil?
      
      Track.new(data[:artist], data[:name], data)
    end
    
    def initialize(artist, name, data={})
      raise ArgumentError, "Artist is required" if artist.nil?
      raise ArgumentError, "Name is required" if name.empty?
      @artist = artist
      @name = name
      populate_data(data)
    end
    
    def add_tags(tags)
        # This function requires authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end

    def ban
        # This function requires authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    @info_loaded = false
    def load_info
        return nil if @info_loaded
        doc = Base.request('track.getinfo', :artist => @artist.name, :track => @name)
        doc.root.children.each do |childL1|
            next unless childL1.name == 'track'
            childL1.children.each do |child|
                @id = child.content.to_i if child.name == 'id'
                @mbid = child.content if child.name == 'mbid'
                @duration = child.content.to_i if child.name == 'duration'
                @url = child.content if child.name == 'url'
                if child.name == 'streamable'
                    if ['1', 'true'].include?(child.content)
                      @streamable = true
                    else
                      @streamable = false
                    end
                end
                @listeners = child.content.to_i if child.name == 'listeners'
                @playcount = child.content.to_i if child.name == 'playcount'
                @artist = Artist.new_from_libxml(child) if child.name == 'artist'
                @album = Album.new_from_libxml(child) if child.name == 'album'
            end
        end
        @info_loaded = true
    end

    def top_fans(force=false)
      call('track.gettopfans', :topfans, User, {:artist => @artist.name, :track => @name})
    end
    
    def top_tags(force=false)
      call('track.gettoptags', :toptags, Tag, {:artist => @artist.name, :track => @name})
    end
    
    def similar
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def tags
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def love
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
    def remove_tag
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def search
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def share
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def ==(otherTrack)
      if otherTrack.is_a?(Scrobbler::Track)
        return ((@name == otherTrack.name) && (@artist == otherTrack.artist))
      end
      false
    end
  end
end
