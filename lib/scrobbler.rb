%w{uri rubygems libxml active_support}.each { |x| require x }

$: << File.expand_path(File.dirname(__FILE__))

require 'scrobbler/base'

require 'scrobbler/album'
require 'scrobbler/artist'
require 'scrobbler/event'
require 'scrobbler/shout'
require 'scrobbler/venue'
require 'scrobbler/geo'
require 'scrobbler/user'
require 'scrobbler/tag'
require 'scrobbler/track'

require 'scrobbler/auth'
require 'scrobbler/library'
require 'scrobbler/playlist'

require 'scrobbler/simpleauth'
require 'scrobbler/scrobble'
require 'scrobbler/playing'

require 'scrobbler/rest'
