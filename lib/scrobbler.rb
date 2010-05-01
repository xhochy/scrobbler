
%w{uri rubygems libxml time}.each { |x| require x }

$: << File.expand_path(File.dirname(__FILE__))

# Load base class
require File.expand_path('scrobbler/base.rb', File.dirname(__FILE__))

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

require 'scrobbler/auth'
require 'scrobbler/library'
require 'scrobbler/playlist'
require 'scrobbler/radio'

require 'scrobbler/simpleauth'
require 'scrobbler/scrobble'
require 'scrobbler/playing'

require 'scrobbler/rest'
