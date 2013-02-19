# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rangeset/version'

Gem::Specification.new do |gem|
  gem.name          = "rangeset"
  gem.version       = RangeSet::VERSION
  gem.authors       = ["Darrick Wiebe"]
  gem.email         = ["dw@xnlogic.com"]
  gem.description   = %q{Set operations on ranges and range sets}
  gem.summary       = %q{Set operations on ranges and range sets}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
