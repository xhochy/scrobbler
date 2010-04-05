begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "scrobbler-ng"
    s.summary = "A ruby library for accessing the last.fm v2 webservices"
    s.email = "uwelk@xhochy.org"
    s.homepage = "http://github.com/xhochy/scrobbler"
    s.description = "A ruby library for accessing the last.fm v2 webservices"
    s.authors = ['John Nunemaker', 'Jonathan Rudenberg', 'Uwe L. Korn']
    if RUBY_PLATFORM =~ /\bjava\b/
      s.add_dependency 'libxml-jruby'
    else
      s.add_dependency 'libxml-ruby'
    end
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
