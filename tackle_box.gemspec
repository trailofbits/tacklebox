# -*- encoding: utf-8 -*-

require File.expand_path('../lib/tackle_box/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "tackle_box"
  gem.version       = TackleBox::VERSION
  gem.summary       = %q{Phishing toolkit}
  gem.description   = %q{A phishing toolkit for generating and sending phishing emails}
  gem.license       = "MIT"
  gem.authors       = ["Hal Brodigan"]
  gem.email         = "hal@trailofbits.com"
  gem.homepage      = "https://github.com/trailofbits/tackle_box"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport',  '~> 3.2'
  gem.add_dependency 'shorturl',       '~> 1.0'
  gem.add_dependency 'liquid',         '~> 2.4'
  gem.add_dependency 'nokogiri',       '~> 1.6'
  gem.add_dependency 'chars',          '~> 0.2'
  gem.add_dependency 'mail',           '~> 2.5'

  gem.add_development_dependency 'bundler', '~> 1.0'
end
