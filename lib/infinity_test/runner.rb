module InfinityTest
  class Runner
    attr_reader :options, :application

    def initialize(argv)
      @options = Options.new(argv)
      @application = InfinityTest.application
    end

    def run!
      @application.load_configuration_file_or_read_the_options!(@options)
      start_continuous_testing!
    end

    # Start Continuous Server using Watchr
    #
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new.start!
    end

  end
end
