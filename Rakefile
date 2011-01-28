# Rakefile

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Dir['tasks/**/*.rake'].each { |rake| load rake }
 
task :default => 'test:unit'
