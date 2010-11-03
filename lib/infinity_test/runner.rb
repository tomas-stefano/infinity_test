module InfinityTest
  class Runner
    attr_reader :options, :application

    def initialize(argv)
      @options = Options.new(argv)
      @application = InfinityTest.application
    end

    def run!
      load_configuration_file_or_read_the_options!
      start_continuous_testing!
    end

    # Load Configuration file first and after that, read the options, parse in the ARGV
    #
    def load_configuration_file_or_read_the_options!
      load_configuration_file
      setup!
      run_global_commands!
    end
    
    def load_configuration_file
      @application.load_configuration_file
    end
    
    def setup!
      @application.config.use(
         :rubies => (options[:rubies] || @application.rubies),
         :test_framework => (options[:test_framework] || @application.config.test_framework),
         :app_framework => (options[:app_framework]   || @application.config.app_framework),
         :verbose => options[:verbose] || @application.config.verbose)
      @application.config.skip_bundler! if options[:skip_bundler?]
      @application.add_heuristics!
      @application.heuristics_users_high_priority!
    end
    
    def run_global_commands!
      @application.run_global_commands!
    end

    # Start Continuous Server using Watchr
    #
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new.start!
    end

  end
end
