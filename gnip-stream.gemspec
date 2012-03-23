# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gnip-stream/version"

Gem::Specification.new do |s|
  s.name        = "gnip-stream"
  s.version     = GnipStream::VERSION
  s.authors     = ["Ryan Weald"]
  s.email       = ["ryan@weald.com"]
  s.homepage    = "https://github.com/rweald/gnip-stream"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "gnip-stream"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "vendor"]

  s.add_development_dependency "rspec"

  s.add_dependency "em-http-request", ">= 1.0.2"
end
