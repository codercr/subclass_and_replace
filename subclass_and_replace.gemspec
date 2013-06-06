# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "subclass_and_replace"
  s.version     = '1.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Carlos Reyna']
  s.email       = ['creyna@ingen10.biz']
  s.homepage    = 'http://github.com/codercr/subclass_and_replace'
  s.summary     = 'Create new class inherited from a class you wish to replace and the ability to revert.'
  s.description = 'Create new class inherited from a class you wish to replace and the ability to revert.'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
end