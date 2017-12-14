# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oath/version'

Gem::Specification.new do |gem|
  gem.name          = "oath"
  gem.version       = Oath::VERSION
  gem.authors       = ["halogenandtoast", "calebthompson"]
  gem.email         = ["halogenandtoast@gmail.com"]
  gem.description   = %q{simple rails authentication}
  gem.summary       = %q{Making rails authentication as simple as possible}
  gem.homepage      = "https://github.com/halogenandtoast/oath"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rails'
  gem.add_dependency 'bcrypt'
  gem.add_dependency 'warden'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'active_hash'
end
