Gem::Specification.new do |s|
  s.name = %q{spotifyit}
  s.version = "0.0.1"
  s.date = %q{2019-04-29}
  s.summary = %q{Spotify Client}
  s.authors = '@jlestebanez'
  s.homepage = 'http://www.nubice.com'
  s.files = [
    "lib/spotifyit.rb"
  ]
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'faraday', '~> 0'
  s.add_runtime_dependency "faraday_middleware", '~> 0'
  s.add_runtime_dependency "oj", '~> 3.7'

end
