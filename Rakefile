# encoding: utf-8
require 'rubygems'
require 'rake'

$:.unshift(File.dirname(__FILE__) + '/lib')

POST_MESSAGE = <<-POST_INSTALL_MESSAGE

  #{ '-' * 80}
                  T O    I N F I N I T Y   A N D   B E Y O N D !!!

   The Infinity uses the awesome RVM to run.
   If you don't have the RVM installed, stop what you doing =p.
   RVM Installation Instructions:
       http://rvm.beginrescueend.com/rvm/install/
   And don't forget to see how you can customize Infinity Test here:
       http://github.com/tomas-stefano/infinity_test/wiki/Customize-Infinity-Test

   Happy Coding! :)

  #{ '-' * 80}

POST_INSTALL_MESSAGE

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "infinity_test"
    gemspec.summary = "Continuous testing and a flexible alternative to Autotest using watchr and RVM"
    gemspec.description = "Infinity Test is a continuous testing library and a flexible alternative to Autotest, using Watchr library with Rspec OR Test::Unit with RVM funcionality, giving the possibility to test with all Rubies that you have in your RVM configuration."
    gemspec.email = "tomasdestefi@gmail.com"
    gemspec.homepage = "http://github.com/tomas-stefano/infinity_test"
    gemspec.authors = ["Tomas D'Stefano"]

    gemspec.add_dependency('watchr', '>= 0.7')
    gemspec.add_dependency('notifiers', '>= 1.1.0')
    
    gemspec.add_development_dependency('rspec', '>= 2.0.1')
    gemspec.add_development_dependency('jeweler', '>= 1.4.0')

    gemspec.post_install_message = POST_MESSAGE
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts("-" * 80)
  puts "Jeweler not available. Install it with:
  [sudo] gem install jeweler"
  puts("-" * 80)
end


require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new("spec") do |t|
  t.pattern = "./spec/infinity_test/**/*_spec.rb"
end

task :default => :spec