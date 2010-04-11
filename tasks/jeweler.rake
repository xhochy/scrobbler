begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "scrobbler-ng"
    s.summary = "A ruby library for accessing the last.fm v2 webservices"
    s.email = "uwelk@xhochy.org"
    s.homepage = "http://github.com/xhochy/scrobbler"
    s.description = "A ruby library for accessing the last.fm v2 webservices"
    s.authors = ['John Nunemaker', 'Jonathan Rudenberg', 'Uwe L. Korn']
    s.add_development_dependency "rspec", ">= 1.2.9"
    s.add_development_dependency "yard", ">= 0"
    s.add_development_dependency "fakeweb", ">= 0"
    #if RUBY_PLATFORM =~ /\bjava\b/
    #  s.add_dependency 'libxml-jruby'
    #else
    #  s.add_dependency 'libxml-ruby'
    #end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
