$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "redis_r/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "redis_r"
  s.version     = RedisR::VERSION
  s.authors     = ["duyetpt"]
  s.email       = ["duyetpt@onaclover.com"]
  s.homepage    = "https://wefit.vn"
  s.summary     = "User map in redis to persit object."
  s.description = "This gem help to save object in redis as a hash."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "redis"
  s.add_dependency "oj"

  s.add_development_dependency "rubocop"
  s.add_development_dependency "rspec"
end
