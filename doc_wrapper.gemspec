# -*- encoding: utf-8 -*-
require File.expand_path("../lib/doc_wrapper/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "doc_wrapper"
  s.version     = DocWrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Mark Menard' ]
  s.email       = [ 'mark@enablelabs.com' ]
  s.homepage    = "http://rubygems.org/gems/doc_wrapper"
  s.summary     = "Declarative DSL for defining classes to wrap HTML DOM Documents"
  s.description = "Using the DocWrapper DSL you can easily define classes that wrap HTML DOM Documents allowing extraction of properties using either XPath or CSS selectors."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "doc_wrapper"
  
  s.add_dependency "activesupport", ">= 3.0.0"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "ZenTest"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
