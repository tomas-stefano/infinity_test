require 'watchr'

module InfinityTest
  class Runner
    attr_reader :commands, :options, :application
    
    def initialize(options)
      @options = options
      @commands = []
      @application = InfinityTest.application
    end

    def run!
      application.resolve_ruby_versions(options[:ruby_versions]) if options[:ruby_versions]
      test_framework!
      cucumber_library!
      run_command_and_wait!
    end
    
    def test_framework!
      @commands.push(application.load_rspec_style) if options[:test_framework].equal?(:rspec)
    end
    
    def cucumber_library!
      @commands.push(application.load_cucumber_style) if options[:cucumber]
    end
    
    def run_command_and_wait!
      @commands.each do |command|
        puts command
        system(command)
      end
    end

  end
end