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
      @application.load_configuration_file
      @application.setup!(options)
      @application.run_global_commands!
    end

    # Start Continuous Server using Watchr
    #
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new.start!
    end

  end
end
