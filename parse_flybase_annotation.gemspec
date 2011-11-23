# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "parse_flybase_annotation/version"

Gem::Specification.new do |s|
  s.name        = "parse_flybase_annotation"
  s.version     = ParseFlybaseAnnotation::VERSION
  s.authors     = ["Andrey Zaika"]
  s.email       = ["anzaika@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{a lib to parse flybase annotation dump}
  s.description = %q{}

  s.rubyforge_project = "parse_flybase_annotation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Development dependencies
  s.add_development_dependency "cucumber"
  s.add_development_dependency "fakefs"
  s.add_development_dependency "rspec"

  # Runtime dependencies
  s.add_runtime_dependency "my_ruby_extensions"

end
