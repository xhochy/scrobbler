# encoding: utf-8

## ## library.getartists
{
  'api_key=foo123&user=xhochy' => 'artists-p1.xml',
  'limit=30&api_key=foo123&user=xhochy' => 'artists-f30.xml'
}.each do |url, file|
  register_fw('method=library.getartists&' + url, 'library', file)
end
(1..7).each do |n|
  register_fw('method=library.getartists&page=' + n.to_s +
    '&api_key=foo123&user=xhochy', 'library', "artists-p#{n}.xml")
end

## ## library.gettracks
{
  'api_key=foo123&user=xhochy' => 'tracks-p1.xml',
  'limit=30&api_key=foo123&user=xhochy' => 'tracks-f30.xml'
}.each do |url, file|
  register_fw('method=library.gettracks&' + url, 'library', file)
end
(1..34).each do |n|
  register_fw("user=xhochy&page=#{n}&api_key=foo123&method=library.gettracks", 
    'library', "tracks-p#{n}.xml")
end

## ## library.getalbums
FakeWeb.register_uri(:get, WEB_BASE + 'limit=30&user=xhochy&api_key=foo123&method=library.getalbums', :body => File.join([FIXTURES_BASE, 'library', 'albums-f30.xml']))
FakeWeb.register_uri(:get, WEB_BASE + 'user=xhochy&api_key=foo123&method=library.getalbums', :body => File.join([FIXTURES_BASE, 'library', 'albums-p1.xml']))
(1..8).each do |n|
  FakeWeb.register_uri(:get, WEB_BASE + 'method=library.getalbums&page=' + 
    n.to_s + '&api_key=foo123&user=xhochy', 
    :body => File.join([FIXTURES_BASE, 'library', 'albums-p' +
    n.to_s + '.xml']))  
end
