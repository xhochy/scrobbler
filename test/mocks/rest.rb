# encoding: utf-8

require 'rubygems'
require 'fakeweb'

FIXTURES_BASE = File.join([File.dirname(__FILE__), '..', 'fixtures', 'xml'])
WEB_BASE = 'http://ws.audioscrobbler.com:80/2.0/?'
FakeWeb.allow_net_connect = false

def register_fw(uri, *args)
  FakeWeb.register_uri(:get, WEB_BASE + uri,
    :body => File.join([FIXTURES_BASE] + args))
end

## Library
require File.expand_path('library.rb', File.dirname(__FILE__))

## Event
register_fw('method=event.getattendees&event=328799&api_key=foo123',
  'event', 'attendees.xml')
register_fw('event=328799&api_key=foo123&method=event.getshouts',
  'event', 'shouts.xml')
register_fw('event=328799&api_key=foo123&method=event.getinfo',
  'event', 'event.xml')
FakeWeb.register_uri(:post, WEB_BASE + 'api_key=foo123&event=328799&method=event.attend&sk=d580d57f32848f5dcf574d1ce18d78b2&status=1&api_sig=c476ec753082205327b0f6ef922d82c8',
  :body => File.join([FIXTURES_BASE, 'event', 'attend.xml']))

## Tag
register_fw('tag=rock&api_key=foo123&method=tag.gettoptracks',
  'tag', 'toptracks.xml')
register_fw('method=tag.gettoptags&api_key=foo123',
  'tag', 'toptags.xml')
register_fw('method=tag.getsimilar&tag=rock&api_key=foo123',
  'tag', 'similar.xml')
register_fw('tag=rock&api_key=foo123&method=tag.gettopartists',
  'tag', 'topartists.xml')
register_fw('tag=rock&api_key=foo123&method=tag.gettopalbums',
  'tag', 'topalbums.xml')

## Venue
register_fw('method=venue.getevents&api_key=foo123&venue=9027137', 
  'venue', 'events.xml')
register_fw('method=venue.getpastevents&api_key=foo123&venue=9027137',
  'venue', 'events.xml')

## Auth
register_fw('api_key=foo123&method=auth.gettoken&api_sig=d062b3b3fa109d048732819d27d04689', 
  'auth', 'token.xml')
register_fw('api_key=foo123&method=auth.getsession&token=test123token&api_sig=f4a839c10a010368bd1058725c253dfb', 
  'auth', 'session.xml')

## Artist
register_fw('artist=Metallica&method=artist.getinfo&api_key=foo123', 
  'artist', 'info.xml')
register_fw('artist=Metallica&api_key=foo123&method=artist.gettoptags',
  'artist', 'toptags.xml')
register_fw('artist=Metallica&api_key=foo123&method=artist.gettopfans',
  'artist', 'fans.xml')
register_fw('artist=Metallica&api_key=foo123&method=artist.gettopalbums',
  'artist', 'topalbums.xml')
register_fw('artist=Metallica&api_key=foo123&method=artist.getsimilar',
  'artist', 'similar.xml')
register_fw('artist=Metallica&api_key=foo123&method=artist.gettoptracks',
  'artist', 'toptracks.xml')

## Track
register_fw('api_key=foo123&method=track.getinfo&artist=Carrie%20Underwood&track=Before%20He%20Cheats',
  'track', 'info.xml')
register_fw('artist=Cher&track=Before%20He%20Cheats&api_key=foo123&method=track.gettopfans',
  'track', 'fans.xml')
register_fw('artist=Cher&track=Before%20He%20Cheats&api_key=foo123&method=track.gettoptags',
  'track', 'toptags.xml')
register_fw('fingerprintid=1234&api_key=foo123&method=track.getFingerprintMetadata',
  'track', 'fingerprintmetadata.xml')

## Geo
FakeWeb.register_uri(:get, WEB_BASE + 'location=Manchester&api_key=foo123&method=geo.getevents', :body => File.join([FIXTURES_BASE, 'geo', 'events-p1.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'location=Manchester&page=2&api_key=foo123&method=geo.getevents', :body => File.join([FIXTURES_BASE, 'geo', 'events-p2.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'location=Manchester&page=3&api_key=foo123&method=geo.getevents', :body => File.join([FIXTURES_BASE, 'geo', 'events-p3.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'distance=15&api_key=foo123&method=geo.getevents', :body => File.join([FIXTURES_BASE, 'geo', 'events-distance-p1.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'lat=40.71417&long=-74.00639&api_key=foo123&method=geo.getevents', :body => File.join([FIXTURES_BASE, 'geo', 'events-lat-long.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'location=Spain&api_key=foo123&method=geo.gettopartists', :body => File.join([FIXTURES_BASE, 'geo', 'top_artists-p1.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'location=Germany&api_key=foo123&method=geo.gettoptracks', :body => File.join([FIXTURES_BASE, 'geo', 'top_tracks-p1.xml']))

# User
register_fw('method=user.getplaylists&api_key=foo123&user=jnunemaker', 
  'user', 'playlists.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getweeklytrackchart',
  'user', 'weeklytrackchart.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getweeklyartistchart',
  'user', 'weeklyartistchart.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getweeklyalbumchart',
  'user', 'weeklyalbumchart.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getevents',
  'user', 'events.xml')
register_fw('user=jnunemaker&period=overall&api_key=foo123&method=user.gettoptracks',
  'user', 'toptracks.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.gettoptags',
  'user', 'toptags.xml')
register_fw('user=jnunemaker&period=overall&api_key=foo123&method=user.gettopartists',
  'user', 'topartists.xml')
register_fw('user=jnunemaker&period=overall&api_key=foo123&method=user.gettopalbums',
  'user', 'topalbums.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getneighbours',
  'user', 'neighbours.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getfriends',
  'user', 'friends.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getfriends&page=1',
  'user', 'friends.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getrecenttracks',
  'user', 'recenttracks.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getlovedtracks',
  'user', 'lovedtracks.xml')
register_fw('user=jnunemaker&api_key=foo123&method=user.getinfo',
  'user', 'info.xml')
  
# Album
register_fw('artist=Carrie%20Underwood&album=Some%20Hearts&api_key=foo123&method=album.getinfo',
  'album', 'info.xml')
FakeWeb.register_uri(:post, WEB_BASE + 'api_key=foo123&method=album.addTags&sk=d580d57f32848f5dcf574d1ce18d78b2&tags=tag1%2Ctag2&api_sig=ab00d1e2baf1c820f889f604ca86535d',
  :body => File.join([FIXTURES_BASE, 'album', 'addtags.xml']))

# Authentication
register_fw('api_key=foo123&authToken=3cf8871e1ce17fbfad72d49007ec2aad&method=auth.getMobileSession&username=john&api_sig=6b9c4b9732a6bb0339bcbbc9ecbcd4dd', 
  'auth', 'mobile.xml')
register_fw('api_key=foo123&method=auth.getToken&api_sig=1cc6b6f01a027f166a21ca8fe0c693b3',
  'auth', 'token.xml')
register_fw('api_key=foo123&method=auth.getSession&token=0e6af5cd2fff6b314994af5b0c58ecc1&api_sig=2f8e52b15b36e8ca1356e7337364b84b',
  'auth', 'session.xml')