# encoding: utf-8

require 'rubygems'
require 'uri'
require 'time'

$: << File.expand_path(File.dirname(__FILE__))

# Load base class
#require File.expand_path('scrobbler/base.rb', File.dirname(__FILE__))
require 'scrobbler/base'

# Load helper modules
require 'scrobbler/helper/image'
require 'scrobbler/helper/streamable'

require 'scrobbler/album'
require 'scrobbler/artist'
require 'scrobbler/event'
require 'scrobbler/shout'
require 'scrobbler/venue'
require 'scrobbler/geo'
require 'scrobbler/user'
require 'scrobbler/session'
require 'scrobbler/tag'
require 'scrobbler/track'

require 'scrobbler/library'
require 'scrobbler/playlist'
require 'scrobbler/radio'

require 'scrobbler/rest'
require 'scrobbler/authentication'