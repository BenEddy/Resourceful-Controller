# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "resourceful_controller/version"

Gem::Specification.new do |s|
  s.name        = "resourceful_controller"
  s.version     = ResourcefulController::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Eddy"]
  s.email       = ["bae@foraker.com"]
  s.homepage    = ""
  s.summary     = %q{Adds standard REST actions to a controller}
  s.description = %q{Adds standard REST actions to a controller}

  s.rubyforge_project = "resourceful_controller"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails"
  s.add_development_dependency "rspec-rails"
end
