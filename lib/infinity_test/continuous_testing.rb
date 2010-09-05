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
      add_signal
      controller = Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do |file|
        @runner.run_commands!
      end
    end
    
    def add_signal
      Signal.trap 'INT' do
        if @sent_an_int then      
           puts " Shutting down now"
           exit
        else
           puts " Interrupt a second time to quit"
           @sent_an_int = true
           Kernel.sleep 1.1
           @runner.run_commands!
           @sent_an_int = false 
        end       
      end      
    end
    
  end
end