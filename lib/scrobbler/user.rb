# encoding: utf-8

module Scrobbler  
  class User < Base
    # Load Helper modules
    include ImageObjectFuncs
    extend  ImageClassFuncs
    
    attr_reader :username, :url, :weight, :match, :realname, :name
    
    def self.new_from_libxml(xml)
      data = {}
      xml.children.each do |child|
        data[:name] = child.content if child.name == 'name'
        data[:url] = child.content if child.name == 'url'
        data[:weight] = child.content.to_i if child.name == 'weight'
        data[:match] = child.content if child.name == 'match'
        data[:realname] = child.content if child.name == 'realname'
        maybe_image_node(data, child)
      end
      User.new(data[:name], data)
    end

    def find(*args)
      options = {:include_profile => false}
      options.merge!(args.pop) if args.last.is_a?(Hash)
      users = args.flatten.inject([]) { |users, u| users << User.new(u, options); users }
      users.length == 1 ? users.pop : users
    end
    
    def initialize(username, input={})
      data = {:include_profile => false}.merge(input)
      raise ArgumentError if username.empty?
      @username = username
      @name = @username
      load_profile() if data[:include_profile]
      populate_data(data)
    end
    
    # Get a list of upcoming events that this user is attending. 
    #
    # Supports ical, ics or rss as its format  
    def events
      call('user.getevents', :events, :event, {:user => @username})
    end

    # Get a list of the user's friends on Last.fm.    
    def friends(page=1, limit=50)
      call('user.getfriends', :friends, :user, {:user => @username, :page => page, :limit => limit})
    end
    
    # Get information about a user profile.
    def load_info
        # This function requires authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    # Get the last 50 tracks loved by a user.
    def loved_tracks
        call('user.getlovedtracks', :lovedtracks, :track, {:user => @username})
    end

    # Get a list of a user's neighbours on Last.fm.
    def neighbours
      call('user.getneighbours', :neighbours, :user, {:user => @username})
    end

    # Get a paginated list of all events a user has attended in the past. 
    def past_events(format=:ics)
      # This needs a Event class, which is yet not available
      raise NotImplementedError
    end
    
    # Get a list of a user's playlists on Last.fm. 
    def playlists
      call('user.getplaylists', :playlists, :playlist, {:user => @username})
    end
    
    # Get a list of the recent tracks listened to by this user. Indicates now 
    # playing track if the user is currently listening.
    #
    # Possible parameters:
    #   - limit: An integer used to limit the number of tracks returned.
    def recent_tracks(parameters={})
      parameters.merge!({:user => @username})
      call('user.getrecenttracks', :recenttracks, :track, parameters)
    end
    
    # Get Last.fm artist recommendations for a user
    def recommended_artists
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    # Get a paginated list of all events recommended to a user by Last.fm, 
    # based on their listening profile. 
    def recommended_events
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    # Get shouts for this user.
    def shouts
      # This needs a Shout class which is yet not available
      raise NotImplementedError
    end
    
    # Get the top albums listened to by a user. You can stipulate a time period. 
    # Sends the overall chart by default. 
    def top_albums(period='overall')
      call('user.gettopalbums', :topalbums, :album, {:user => @username, :period => period})
    end

    # Get the top artists listened to by a user. You can stipulate a time 
    # period. Sends the overall chart by default. 
    def top_artists(period='overall')
      call('user.gettopartists', :topartists, :artist, {:user => @username, :period => period})
    end

    #  Get the top tags used by this user.
    def top_tags
      call('user.gettoptags', :toptags, :tag, {:user => @username})
    end

    # Get the top tracks listened to by a user. You can stipulate a time period. 
    # Sends the overall chart by default. 
    def top_tracks(period='overall')
      call('user.gettoptracks', :toptracks, :track, {:user => @username, :period => period})
    end

    # Setup the parameters for a *chart API call
    def setup_chart_params(from=nil, to=nil)
      parameters = {:user => @username}
      parameters[:from] = from unless from.nil?
      parameters[:to] = to unless to.nil?
      parameters
    end

    # Get an album chart for a user profile, for a given date range. If no date 
    # range is supplied, it will return the most recent album chart for this 
    # user. 
    def weekly_album_chart(from=nil, to=nil)
      parameters = setup_chart_params(from, to)
      call('user.getweeklyalbumchart', :weeklyalbumchart, :album, parameters)
    end
    
    # Get an artist chart for a user profile, for a given date range. If no date
    # range is supplied, it will return the most recent artist chart for this 
    # user. 
    def weekly_artist_chart(from=nil, to=nil)
      parameters = setup_chart_params(from, to)
      call('user.getweeklyartistchart', :weeklyartistchart, :artist, parameters)
    end
    
    # Get a list of available charts for this user, expressed as date ranges 
    # which can be sent to the chart services. 
    def weekly_chart_list(force=false)
      # @todo
      raise NotImplementedError
    end

    # Get a track chart for a user profile, for a given date range. If no date 
    # range is supplied, it will return the most recent track chart for this 
    # user. 
    def weekly_track_chart(from=nil, to=nil)
      parameters = setup_chart_params(from, to)
      call('user.getweeklytrackchart', :weeklytrackchart, :track, parameters)
    end
    
    # Shout on this user's shoutbox
    def shout(message)
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
  end
end
