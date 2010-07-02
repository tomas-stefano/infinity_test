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
    #  Calling `run` will enter the listening loop, and from then on every
    #  file event will trigger its corresponding action defined in `script`
    #  
    #  The controller also automatically adds the script's file to its list of
    #  monitored files and will detect any changes to it, providing on the fly
    #  updates of defined rules.
    #
    def run_command_and_wait!
      path = Pathname.new(File.expand_path(__FILE__))
      @script = Watchr::Script.new(path)
      run_commands!
      @script.watch('^spec/(.*)_spec.rb') do        
        print 'Yeah'
        run_commands!
      end
      controller = Watchr::Controller.new(@script, Watchr.handler.new)
      controller.run
    end
    
    def run_commands!
      @commands.each do |command|
        puts command
        system(command)
      end
    end

  end
end