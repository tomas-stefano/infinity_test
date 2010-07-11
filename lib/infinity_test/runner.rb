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
    
    # Using Watchr Library to listening file events
    #
    #  Example:
    #
    #   script = Watchr::Script.new(file)
    #   contrl = Watchr::Controller.new(script, Watchr.handler.new)
    #   contrl.run
    #
    def run_command_and_wait!
      run_commands!
      script = Watchr::Script.new
      script.watch('^spec/(.*)_spec.rb') do
        run_commands!
      end
      controller = Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def run_commands!
      @commands.each do |command|
        puts command
        system(command)
      end
    end

  end
end