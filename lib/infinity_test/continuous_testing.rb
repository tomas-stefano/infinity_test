module InfinityTest
  class ContinuousTesting
    attr_accessor :test_framework, :cucumber, :runner
    
    def initialize(options)
      @test_framework = options[:test_framework]
      @cucumber = options[:cucumber]
      @runner = options[:runner]
    end
    
    def library_directory_pattern
      "^lib/(.*)\.rb"
    end
    
    def test_directory_pattern
      if @test_framework.equal?(:rspec)
        "^spec/(.*)_spec.rb"
      else
        "^test/(.*)_test.rb"
      end
    end
    
    def start!
      script = Watchr::Script.new
      add_rule script, :rule => library_directory_pattern
      add_rule script, :rule => test_directory_pattern
      controller = Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do
        @runner.run_commands!
      end
    end
    
  end
end