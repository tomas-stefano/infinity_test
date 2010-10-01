require 'optparse'

module InfinityTest
  class Options < Hash
        
    def initialize(arguments)
      super()
      @options = OptionParser.new do |options|
        parse_rspec(options)
        parse_bacon(options)
        parse_test_unit(options)
        parse_rubies(options)
        parse_verbose(options)
        options.banner = [ "Usage: infinity_test [options]", "Starts a continuous test server."].join("\n")        
        options.on_tail("--help", "You're looking at it.") do
          print options.help
          exit
        end
      end
      @options.parse!(arguments.clone)
    end
    
    def parse_rspec(options)
      options.on('--rspec', 'Rspec Framework') do
        self[:test_framework] = :rspec
      end
    end
    
    def parse_test_unit(options)
      options.on('--test-unit', 'Test Unit') do
        self[:test_framework] = :test_unit
      end
    end
    
    def parse_bacon(options)
      options.on('--bacon', 'Bacon') do
        self[:test_framework] = :bacon
      end
    end
    
    def parse_rubies(options)
      options.on('--rubies=rubies', 'Specify the Ruby Versions for Testing with several Rubies') do |versions|
        self[:rubies] = versions
      end
    end
    
    def parse_verbose(options)
      options.on('--verbose', 'The Infinity Test dont print the commands. To print the command set this options!') do
        self[:verbose] = true
      end
    end
    
    def rspec?
      return true if self[:test_framework].equal?(:rspec)
      false
    end
    
    def bacon?
      return true if self[:test_framework].equal?(:bacon)
      false
    end
    
  end
end
