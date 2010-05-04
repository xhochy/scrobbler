# encoding: utf-8

module Scrobbler
  class Tag < Base
    attr_reader :name, :count, :url, :streamable
    
    def self.new_from_libxml(xml)
      data = {}
      xml.children.each do |child|
        data[:name] = child.content if child.name == 'name'
        data[:count] = child.content.to_i if child.name == 'count'
        data[:url] = child.content if child.name == 'url'
        if child.name == 'streamable'
          if ['1', 'true'].include?(child.content)
            data[:streamable] = true
          else
            data[:streamable] = false
          end
        end
      end
      
      Tag.new(data[:name], data)
    end
    
    def initialize(name, data={})
      raise ArgumentError, "Name is required" if name.empty?
      @name = name
      @url = data[:url] unless data[:url].nil?
      @count = data[:count] unless data[:count].nil?
      @streamable = data[:streamable] unless data[:streamable].nil?
    end
    
    def top_artists(force=false)
      get_response('tag.gettopartists', :top_artists, 'topartists', 'artist', {'tag'=>@name}, force)
    end
    
    def top_albums(force=false)
      get_response('tag.gettopalbums', :top_albums, 'topalbums', 'album', {'tag'=>@name}, force)
    end

    def top_tracks(force=false)
      get_response('tag.gettoptracks', :top_tracks, 'toptracks', 'track', {'tag'=>@name}, force)
    end

    def self.top_tags
        Base.get('tag.gettoptags', :toptags, :tag)
    end
    
    def self.search
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    
    # Search for tags similar to this one. Returns tags ranked by similarity, 
    # based on listening data.
    def similar(force=false)
        params = {:tag => @name}
        get_response('tag.getsimilar', :similar, 'similartags', 'tag', params, force)
    end

    def weekly_artist_chart
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def weekly_chart_list
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

  end
end
