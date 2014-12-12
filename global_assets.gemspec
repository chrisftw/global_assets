Gem::Specification.new do |s|
  s.name = "global_assets"
  s.version = "0.0.0"
  s.summary = "Global asset manager for Ruby projects that share assets."
  s.description = "Share all your assets between all your projects via personal gem/git repo."
  s.authors = ["Chris Reister"]
  s.licenses = ["MIT"]
  s.email = ["chris@chrisreister.com"]
  s.homepage = "https://github.com/chrisftw/global_assets"
  s.files = ["lib/global_assets.rb", "Rakefile"]

  s.add_development_dependency 'minitest'
end
