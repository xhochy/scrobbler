# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scrobbler-ng}
  s.version = "2.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker", "Jonathan Rudenberg", "Uwe L. Korn"]
  s.date = %q{2010-09-18}
  s.description = %q{A ruby library for accessing the Last.fm 2.0 API. It is higly optimized so that it uses less memory and parses XML (through Nokogiri) than other implementations.}
  s.email = %q{uwelk@xhochy.org}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "examples/album.rb",
     "examples/artist.rb",
     "examples/scrobble.rb",
     "examples/tag.rb",
     "examples/track.rb",
     "examples/user.rb",
     "lib/scrobbler.rb",
     "lib/scrobbler/album.rb",
     "lib/scrobbler/artist.rb",
     "lib/scrobbler/authentication.rb",
     "lib/scrobbler/base.rb",
     "lib/scrobbler/basexml.rb",
     "lib/scrobbler/basexmlinfo.rb",
     "lib/scrobbler/event.rb",
     "lib/scrobbler/geo.rb",
     "lib/scrobbler/helper/image.rb",
     "lib/scrobbler/helper/streamable.rb",
     "lib/scrobbler/library.rb",
     "lib/scrobbler/playlist.rb",
     "lib/scrobbler/radio.rb",
     "lib/scrobbler/session.rb",
     "lib/scrobbler/shout.rb",
     "lib/scrobbler/tag.rb",
     "lib/scrobbler/track.rb",
     "lib/scrobbler/user.rb",
     "lib/scrobbler/venue.rb",
     "scrobbler-ng.gemspec",
     "tasks/jeweler.rake",
     "tasks/rdoc.rake",
     "tasks/tests.rake",
     "tasks/yardoc.rake"
  ]
  s.homepage = %q{http://github.com/xhochy/scrobbler}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A ruby library for accessing the last.fm v2 webservices}
  s.test_files = [
    "test/spec_helper.rb",
     "test/unit/user_spec.rb",
     "test/unit/radio_spec.rb",
     "test/unit/tag_spec.rb",
     "test/unit/geo_spec.rb",
     "test/unit/venue_spec.rb",
     "test/unit/simpleauth_test.rb",
     "test/unit/playlist_spec.rb",
     "test/unit/track_spec.rb",
     "test/unit/artist_spec.rb",
     "test/unit/event_spec.rb",
     "test/unit/album_spec.rb",
     "test/unit/authentication_spec.rb",
     "test/unit/playing_test.rb",
     "test/unit/library_spec.rb",
     "test/mocks/rest.rb",
     "test/mocks/library.rb",
     "test/test_helper.rb",
     "examples/track.rb",
     "examples/album.rb",
     "examples/artist.rb",
     "examples/tag.rb",
     "examples/user.rb",
     "examples/scrobble.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.2"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
  end
end

