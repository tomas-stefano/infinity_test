require 'optparse'

module InfinityTest
  class Options < Hash
        
    def initialize(arguments)
      super()
      @options = OptionParser.new do |options|
        [:test_unit, :rspec, :bacon, :rubygems, :rails, :rubies, :cucumber, :verbose, :patterns, :bundler].each do |name|
          send("parse_#{name}", options)
        end
        options.banner = [ "Usage: infinity_test [options]", "Starts a continuous test server."].join("\n")        
        options.on_tail("--help", "You're looking at it.") do
          print options.help
          exit
        end
      end
      @options.parse!(arguments.clone)
    end
    
    def parse_rspec(options)
      options.on('--rspec', 'Test Framework: Rspec') do
        self[:test_framework] = :rspec
      end
    end
    
    def parse_test_unit(options)
      options.on('--test-unit', 'Test Framework: Test Unit [Default]') do
        self[:test_framework] = :test_unit
      end
    end
    
    def parse_bacon(options)
      options.on('--bacon', 'Test Framework: Bacon') do
        self[:test_framework] = :bacon
      end
    end
    
    def parse_rubies(options)
      options.on('--rubies=rubies', 'Specify the Ruby Versions for Testing with many Rubies') do |versions|
        self[:rubies] = versions
      end
    end
    
    def parse_verbose(options)
      options.on('--verbose', 'The Infinity Test dont print the commands', 'To print the commands set this option!') do
        self[:verbose] = true
      end
    end
    
    def parse_rails(options)
      options.on('--rails', 'Application Framework: Rails') do
        self[:app_framework] = :rails
      end
    end

    def parse_rubygems(options)
      options.on('--rubygems', 'Application Framework: Rubygems (Default)') do
        self[:app_framework] = :rubygems
      end
    end
    
    def parse_cucumber(options)
      options.on('--cucumber', 'Run with the Cucumber too') do
        self[:cucumber] = true
      end
    end
    
    def parse_patterns(options)
      options.on('--heuristics', 'Show all the Default Patterns and added by #heuristics method and EXIT.') do
        self[:show_heuristics?] = true
      end
    end
    
    def parse_bundler(options)
      options.on('--skip-bundler', "InfinityTest try to use bundler if Gemfile is present. If you don't want to use this convention, set this option.") do
        self[:skip_bundler?] = true
      end
    end
    
  end
end
