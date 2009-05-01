# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scrobbler}
  s.version = "0.2.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker, Jonathan Rudenberg, Uwe L. Korn"]
  s.date = %q{2009-05-02}
  s.description = %q{wrapper for audioscrobbler (last.fm) web services}
  s.email = %q{nunemaker@gmail.com}
  s.extra_rdoc_files = ["lib/scrobbler/search.rb", "lib/scrobbler/rest.rb", "lib/scrobbler/track.rb", "lib/scrobbler/simpleauth.rb", "lib/scrobbler/base.rb", "lib/scrobbler/version.rb", "lib/scrobbler/chart.rb", "lib/scrobbler/playing.rb", "lib/scrobbler/artist.rb", "lib/scrobbler/scrobble.rb", "lib/scrobbler/user.rb", "lib/scrobbler/album.rb", "lib/scrobbler/tag.rb", "lib/scrobbler.rb", "README.rdoc"]
  s.files = ["lib/scrobbler/search.rb", "lib/scrobbler/rest.rb", "lib/scrobbler/track.rb", "lib/scrobbler/simpleauth.rb", "lib/scrobbler/base.rb", "lib/scrobbler/version.rb", "lib/scrobbler/chart.rb", "lib/scrobbler/playing.rb", "lib/scrobbler/artist.rb", "lib/scrobbler/scrobble.rb", "lib/scrobbler/user.rb", "lib/scrobbler/album.rb", "lib/scrobbler/tag.rb", "lib/scrobbler.rb", "scrobbler.gemspec", "MIT-LICENSE", "Rakefile", "History.txt", "setup.rb", "README.rdoc", "examples/track.rb", "examples/artist.rb", "examples/scrobble.rb", "examples/user.rb", "examples/album.rb", "examples/tag.rb", "test/unit/album_test.rb", "test/unit/playing_test.rb", "test/unit/scrobble_test.rb", "test/unit/artist_test.rb", "test/unit/chart_test.rb", "test/unit/track_test.rb", "test/unit/tag_test.rb", "test/unit/search_test.rb", "test/unit/simpleauth_test.rb", "test/unit/user_test.rb", "test/test_helper.rb", "test/mocks/rest.rb", "test/fixtures/xml/album/info.xml", "test/fixtures/xml/track/toptags.xml", "test/fixtures/xml/track/fans.xml", "test/fixtures/xml/artist/toptags.xml", "test/fixtures/xml/artist/similar.xml", "test/fixtures/xml/artist/topalbums.xml", "test/fixtures/xml/artist/toptracks.xml", "test/fixtures/xml/artist/fans.xml", "test/fixtures/xml/tag/toptags.xml", "test/fixtures/xml/tag/topalbums.xml", "test/fixtures/xml/tag/toptracks.xml", "test/fixtures/xml/tag/topartists.xml", "test/fixtures/xml/search/track.xml", "test/fixtures/xml/search/artist.xml", "test/fixtures/xml/search/album.xml", "test/fixtures/xml/user/toptags.xml", "test/fixtures/xml/user/recentbannedtracks.xml", "test/fixtures/xml/user/topalbums.xml", "test/fixtures/xml/user/toptracks.xml", "test/fixtures/xml/user/recentlovedtracks.xml", "test/fixtures/xml/user/recenttracks.xml", "test/fixtures/xml/user/friends.xml", "test/fixtures/xml/user/profile.xml", "test/fixtures/xml/user/topartists.xml", "test/fixtures/xml/user/systemrecs.xml", "test/fixtures/xml/user/neighbours.xml", "Manifest"]
  s.has_rdoc = true
  s.homepage = %q{http://scrobbler.rubyforge.org}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Scrobbler", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{scrobbler}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{wrapper for audioscrobbler (last.fm) web services}
  s.test_files = ["test/unit/album_test.rb", "test/unit/playing_test.rb", "test/unit/scrobble_test.rb", "test/unit/artist_test.rb", "test/unit/chart_test.rb", "test/unit/track_test.rb", "test/unit/tag_test.rb", "test/unit/search_test.rb", "test/unit/simpleauth_test.rb", "test/unit/user_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_runtime_dependency(%q<htmlentities>, [">= 4.0.0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_dependency(%q<htmlentities>, [">= 4.0.0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.4.86"])
    s.add_dependency(%q<activesupport>, [">= 1.4.2"])
    s.add_dependency(%q<htmlentities>, [">= 4.0.0"])
  end
end
