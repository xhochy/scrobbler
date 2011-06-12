# Rakefile

require 'rubygems'
require 'rake'
require 'rake/testtask'

Dir['tasks/**/*.rake'].each { |rake| load rake }
 
task :default => 'test:unit'
