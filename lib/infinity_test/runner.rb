module InfinityTest
  class Runner
    attr_reader :options, :application

    def initialize(argv)
      @options = Options.new(argv)
      @application = InfinityTest.application
    end

    # Load all configurations files and read the command line args
    # and start the continuous testing
    #
    def run!
      @application.load_configuration_file_or_read_the_options!(@options)
      if @options[:show_heuristics?]
        list_heuristics!
      else
        @application.run_global_commands!
        start_continuous_testing!
      end
    end
    
    # Run commands for a changed file
    # If dont have a file to test, do nothing
    #
    def run_commands_for_changed_file(files)
      if files and there_are_test_files_to_run?(files)
        commands = @application.construct_commands_for_changed_files(files)
        @application.run!(commands)
      end
    end

    # List all heuristics from application and exit
    #
    def list_heuristics!
      @application.heuristics.patterns.keys.each do |pattern|
        puts %{- "#{pattern}"}
      end
      exit
    end

    # Start Continuous Server using Watchr
    #
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new.start!
    end
    
    private
    
    def there_are_test_files_to_run?(files)
      not files.empty?
    end

  end
end
