module InfinityTest
  class Runner
    attr_reader :commands, :options, :application
    
    def initialize(options)
      @options = options
      @commands = []
      @application = InfinityTest.application
    end
    
    def run!
      load_configuration_file_or_read_the_options!
      start_continuous_testing!
    end
    
    def load_configuration_file_or_read_the_options!
      @application.load_configuration_file
      @application.config.use(
        :rubies => (options[:rubies] || @application.rubies),
        :test_framework => (options[:test_framework] || @application.config.test_framework), 
        :cucumber => (options.include?(:cucumber) ? options[:cucumber] : @application.cucumber?),
        :verbose => options[:verbose] || @application.config.verbose
      )
    end
    
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new(:application => @application).start!
    end

  end
end