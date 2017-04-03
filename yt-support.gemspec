# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/support/version'

Gem::Specification.new do |spec|
  spec.name          = 'yt-support'
  spec.version       = Yt::Support::VERSION
  spec.authors       = ['Claudio Baccigalupo', 'Kang-Kyu Lee']
  spec.email         = ['claudio@fullscreen.net', 'kang-kyu.lee@fullscreen.net']

  spec.summary       = %q{Support utilities for Yt gems}
  spec.description   = %q{Yt::Support provides common functionality to Yt,
    Yt::Auth. It is considered suitable for internal use only at this time.}
  spec.homepage      = 'https://github.com/fullscreen/yt-support'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.20'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'yard', '~> 0.9.8'
end
