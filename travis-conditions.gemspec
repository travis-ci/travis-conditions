# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'travis/conditions/version'

Gem::Specification.new do |s|
  s.name         = "travis-conditions"
  s.version      = Travis::Conditions::VERSION
  s.authors      = ["Travis CI"]
  s.email        = "contact@travis-ci.org"
  s.homepage     = "https://github.com/travis-ci/travis-conditions"
  s.summary      = "Boolean language for conditional builds, stages, jobs"

  s.files        = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.add_dependency 'parslet'
end
