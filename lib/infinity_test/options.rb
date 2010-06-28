require 'optparse'

module InfinityTest
  class Options < Hash
        
    def initialize(arguments)
      super()
      @options = OptionParser.new do |options|
        options.on('--rspec', 'Rspec Framework') do
          self[:test_framework] = :rspec
        end
        options.on('--cucumber', 'Cucumber Library') do
          self[:cucumber] = true
        end
        options.on('--rvm-versions=rubies', 'Specify the Ruby Versions for Testing with several Rubies') do |versions|
          self[:ruby_versions] = versions
        end
        options.banner = [ "Usage: infinity_test [options]", "Starts a continuous test server."].join("\n")        
        options.on_tail("--help", "You're looking at it.") do
          print options.help
          exit
        end
      end
      @options.parse!(arguments.clone)
    end
    
    def rspec?
      return true if self[:test_framework].equal?(:rspec)
      false
    end
    
    def cucumber?
      return true if self[:cucumber]
      false
    end
    
  end
end