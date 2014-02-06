# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infinity_test/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'infinity_test'
  spec.version       = InfinityTest::Core::VERSION
  spec.authors       = ["Tomas D'Stefano"]
  spec.email         = ['tomas_stefano@successoft.com']
  spec.description   = 'Infinity Test is a continuous testing library and a flexible alternative to Autotest and Guard.'
  spec.summary       = 'Infinity Test is a continuous testing library and a flexible alternative to Autotest and Guard.'
  spec.homepage      = 'https://github.com/tomas-stefano/infinity_test'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 3.2.13'
  spec.add_dependency 'watchr'
  spec.add_dependency 'hike', '~> 1.2'
  spec.add_dependency 'notifiers', '>= 1.2.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 2.14'
  spec.add_development_dependency 'simplecov'

  spec.post_install_message = %q{
  --------------------------------------------------------------------------------
                  T O    I N F I N I T Y   A N D   B E Y O N D !!!

   Infinity Test can be used with RVM, RbEnv or just Ruby without package manager.
   If you don't have RVM or Rbenv installed.

   RVM Installation Instructions:
       https://rvm.io/rvm/install/

   Rbenv Installation Instructions:
       https://github.com/sstephenson/rbenv#installation

   And don't forget to see how you can customize Infinity Test here:
       http://github.com/tomas-stefano/infinity_test/wiki/Customize-Infinity-Test

   Happy Coding! :)
  --------------------------------------------------------------------------------
}
end
