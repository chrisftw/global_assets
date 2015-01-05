Gem::Specification.new do |s|
  s.name        = "global_assets"
  s.version     = "0.0.1"
  s.date        = '2015-01-05'
  s.summary     = "Global asset manager for Ruby projects that share assets."
  s.description = "Share HTML snippets, JS, CSS/SASS, and images between all your projects via personal gem/git repo."
  s.authors     = ["Chris Reister"]
  s.licenses    = ["MIT"]
  s.email       = ["chris@chrisreister.com"]
  s.homepage    = "https://github.com/chrisftw/global_assets"
  s.files       = ["lib/global_assets.rb", "Rakefile"]

  s.add_development_dependency 'minitest'
end
