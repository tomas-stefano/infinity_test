begin
  require 'watchr'
rescue LoadError
  require 'rubygems'
  require 'watchr'
end

module InfinityTest
  class Runner
    attr_reader :commands, :options, :application, :patterns
    
    def initialize(options)
      @options = options
      @commands = []
      @application = InfinityTest.application
      @patterns = []
    end

    def run!
      resolve_ruby_versions!
      test_framework!
      cucumber_library!
      run_command_and_wait!
    end
    
    def resolve_ruby_versions!
      application.resolve_ruby_versions(options[:ruby_versions]) if options[:ruby_versions]
    end
    
    def test_framework!
      if options[:test_framework].equal?(:rspec)
        @commands.push(application.load_rspec_style)
      else
        @commands.push(application.load_test_unit_style)
      end
    end
    
    def cucumber_library!
      @commands.push(application.load_cucumber_style) if options[:cucumber]
    end
    
    def run_command_and_wait!
      run_commands!
      start_continuous_server!
    end
    
    def run_commands!
      @commands.compact.each do |command|
        puts command
        system(command)
      end
    end
    
    def start_continuous_server!
      InfinityTest::ContinuousTesting.new(
        :runner => self, 
        :test_framework => options[:test_framework],
        :cucumber => options[:cucumber]
      ).start!
    end

  end
end