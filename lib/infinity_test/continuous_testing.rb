module InfinityTest
  class ContinuousTesting
    attr_accessor :test_framework, :cucumber, :runner
    
    def initialize(options)
      @test_framework = options[:test_framework]
      @cucumber = options[:cucumber]
      @runner = options[:runner]
    end
    
    def start!
      script = Watchr::Script.new
      script.watch('^spec/(.*)_spec.rb') do
        @runner.run_commands!
      end
      controller = Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
  end
end