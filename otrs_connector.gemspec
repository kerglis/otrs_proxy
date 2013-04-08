# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "otrs_connector/version"

Gem::Specification.new do |s|
  s.name        = "otrs_proxy"
  s.version     = OtrsConnector::VERSION
  s.authors     = ["Kristaps Erglis"]
  s.email       = ["kristaps.erglis@gmail.com"]
  s.homepage    = "http://ambicode.com"
  s.summary     = %q{Simple gem to work with otrs}
  s.description = %q{Simple gem to work with otrs}

  s.rubyforge_project = "otrs_connector"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "activesupport", '>= 2.3.14'
  s.add_runtime_dependency "activerecord", '>= 2.3.14'
end
