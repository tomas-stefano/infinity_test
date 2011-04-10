require 'optparse'

module InfinityTest
  class Options < Hash

    def initialize(arguments)
      super()
      @options = OptionParser.new do |options|
        [:test_unit, :rspec, :bacon, :rubygems, :rails, :rubies, :verbose, :patterns, :bundler, :version].each do |name|
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
      options.on('--rspec', 'Test Framework: RSpec') do
        self[:test_framework] = :rspec
      end
    end

    def parse_test_unit(options)
      options.on('--test-unit', 'Test Framework: Test Unit (Default)') do
        self[:test_framework] = :test_unit
      end
    end

    def parse_bacon(options)
      options.on('--bacon', 'Test Framework: Bacon') do
        self[:test_framework] = :bacon
      end
    end

    def parse_rubies(options)
      options.on('--rubies=rubies', 'Specify Ruby version(s) to test against') do |versions|
        rubies = []
        self[:specific_options] = {}
        versions.split(",").each do |r|
          rubie = r.split('+')[0]
          params = r.split('+')[1]
          self[:specific_options][rubie] = params 
          rubies << rubie
        end
        self[:rubies] = rubies.join(',')
      end
    end

    def parse_verbose(options)
      options.on('--verbose', 'Print commands before executing them') do
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

    # def parse_cucumber(options)
    #   options.on('--cucumber', 'Run with the Cucumber too') do
    #     self[:cucumber] = true
    #   end
    # end

    def parse_patterns(options)
      options.on('--heuristics', 'Show all defined heuristics and exit') do
        self[:show_heuristics?] = true
      end
    end

    def parse_bundler(options)
      options.on('--skip-bundler', "Bypass Infinity Test's Bundler support, even if a Gemfile is present") do
        self[:skip_bundler?] = true
      end
    end

    def parse_version(options)
      options.on("--version", "Show version and exit") do
        puts InfinityTest.version
        exit
      end
    end
  end
end
