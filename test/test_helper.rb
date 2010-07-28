require 'test/unit'
require File.expand_path('../lib/scrobbler.rb', File.dirname(__FILE__))
require File.dirname(__FILE__) + '/mocks/rest'

# To test the 2.0 API, we do not need a valid key
Scrobbler::Base.api_key = 'foo123'