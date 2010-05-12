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
    
    def top_artists
      call('tag.gettopartists', :topartists, Artist, {:tag => @name})
    end
    
    def top_albums
      call('tag.gettopalbums', :topalbums, Album, {:tag => @name})
    end

    def top_tracks
      call('tag.gettoptracks', :toptracks, Track, {:tag => @name})
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
    def similar
        call('tag.getsimilar', :similartags, Tag, {:tag => @name})
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
