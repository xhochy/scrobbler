# encoding: utf-8

require File.expand_path('basexmlinfo.rb', File.dirname(__FILE__))

module Scrobbler  
  class User < BaseXmlInfo
    # Load Helper modules
    include ImageObjectFuncs
    
    attr_reader :url, :weight, :match, :realname, :name
    
    # Alias for User.new(:xml => xml)
    #
    # @deprecated
    def self.new_from_libxml(xml)
      User.new(:xml => xml)
    end

    def find(*args)
      options = {:include_profile => false}
      options.merge!(args.pop) if args.last.is_a?(Hash)
      users = args.flatten.inject([]) { |users, u| users << User.new(u, options); users }
      users.length == 1 ? users.pop : users
    end
    
    # Load the data for this object out of a XML-Node
    #
    # @param [LibXML::XML::Node] node The XML node containing the information
    # @return [nil]
    def load_from_xml(node)
      # Get all information from the root's children nodes
      node.children.each do |child|
        case child.name.to_s
          when 'name'
            @name = child.content
          when 'url'
            @url = child.content
          when 'weight'
            @weight = child.content.to_i
          when 'match'
            @match = child.content
          when 'realname'
            @realname = child.content
          when 'image'
            check_image_node(child)
          when 'text'
            # ignore, these are only blanks
          when '#text'
            # libxml-jruby version of blanks
          else
            raise NotImplementedError, "Field '#{child.name}' not known (#{child.content})"
        end #^ case
      end #^ do |child|
    end
    
    def initialize(data={})
      raise ArgumentError unless data.kind_of?(Hash)
      super(data)
      
      raise ArgumentError, "Name is required" if @name.empty?
    end
    
    # Get a list of upcoming events that this user is attending. 
    #
    # Supports ical, ics or rss as its format  
    def events
      call('user.getevents', :events, Event, {:user => @name})
    end

    # Get a list of the user's friends on Last.fm.    
    def friends(opts={})
      result = []
      if opts.delete :all
        params = {:page => 1, :limit => 50, :user => @name}.merge(opts)
        doc = Base.request('user.getfriends', params)
        root = nil
        doc.root.children.each do |child|
          next unless child.name == 'friends'
          root = child
        end
        total_pages = root['totalPages'].to_i
        root.children.each do |child|
          next unless child.name == 'user'
          result << Scrobbler::User.new_from_libxml(child)
        end
        puts total_pages
        (2..total_pages).each do |i|
          params[:page] = i
          result.concat call('user.getfriends', :friends, User, params)
        end
      else
        params = {:page => 1, :limit => 50, :user => @name}.merge(opts)
        result = call('user.getfriends', :friends, User, params)
      end
      result
    end
    
    # Get information about a user profile.
    def load_info
        # This function requires authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    # Get the last 50 tracks loved by a user.
    def loved_tracks
        call('user.getlovedtracks', :lovedtracks, Track, {:user => @name})
    end

    # Get a list of a user's neighbours on Last.fm.
    def neighbours
      call('user.getneighbours', :neighbours, User, {:user => @name})
    end

    # Get a paginated list of all events a user has attended in the past. 
    def past_events(format=:ics)
      # This needs a Event class, which is yet not available
      raise NotImplementedError
    end
    
    # Get a list of a user's playlists on Last.fm. 
    def playlists
      call('user.getplaylists', :playlists, Playlist, {:user => @name})
    end
    
    # Get a list of the recent tracks listened to by this user. Indicates now 
    # playing track if the user is currently listening.
    #
    # Possible parameters:
    #   - limit: An integer used to limit the number of tracks returned.
    def recent_tracks(parameters={})
      parameters.merge!({:user => @name})
      call('user.getrecenttracks', :recenttracks, Track, parameters)
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
    def top_albums(period=:overall)
      call('user.gettopalbums', :topalbums, Album, {:user => @name, :period => period})
    end

    # Get the top artists listened to by a user. You can stipulate a time 
    # period. Sends the overall chart by default. 
    def top_artists(period=:overall)
      call('user.gettopartists', :topartists, Artist, {:user => @name, :period => period})
    end

    #  Get the top tags used by this user.
    def top_tags
      call('user.gettoptags', :toptags, Tag, {:user => @name})
    end

    # Get the top tracks listened to by a user. You can stipulate a time period. 
    # Sends the overall chart by default. 
    def top_tracks(period=:overall)
      call('user.gettoptracks', :toptracks, Track, {:user => @name, :period => period})
    end

    # Setup the parameters for a *chart API call
    def setup_chart_params(from=nil, to=nil)
      parameters = {:user => @name}
      parameters[:from] = from unless from.nil?
      parameters[:to] = to unless to.nil?
      parameters
    end

    # Get an album chart for a user profile, for a given date range. If no date 
    # range is supplied, it will return the most recent album chart for this 
    # user. 
    def weekly_album_chart(from=nil, to=nil)
      parameters = setup_chart_params(from, to)
      call('user.getweeklyalbumchart', :weeklyalbumchart, Album, parameters)
    end
    
    # Get an artist chart for a user profile, for a given date range. If no date
    # range is supplied, it will return the most recent artist chart for this 
    # user. 
    def weekly_artist_chart(from=nil, to=nil)
      parameters = setup_chart_params(from, to)
      call('user.getweeklyartistchart', :weeklyartistchart, Artist, parameters)
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
      call('user.getweeklytrackchart', :weeklytrackchart, Track, parameters)
    end
    
    # Shout on this user's shoutbox
    def shout(message)
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
  end
end
