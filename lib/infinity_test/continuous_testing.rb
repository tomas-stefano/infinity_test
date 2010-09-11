module InfinityTest
  class ContinuousTesting
    attr_accessor :application, :library_directory_pattern, :results
    
    def initialize(options)
      @application = options[:application]      
      @results = {}
    end
    
    def start!
      @global_commands = test_framework.construct_commands
      run! @global_commands
      initialize_watchr!
    end
    
    def test_framework
      @test_framework ||= @application.test_framework.equal?(:rspec) ? Rspec.new(:rubies => @application.rubies) : TestUnit.new(:rubies => @application.rubies)
    end
    
    def initialize_watchr!
      script = Watchr::Script.new
      add_rule script, :rule => @application.library_directory_pattern
      add_rule script, :rule => test_framework.test_directory_pattern
      add_signal
      Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def run!(commands)
      commands.each do |ruby_version, command|
        puts "\n* Using #{ruby_version}" ; puts
        puts command
        command = Command.new(:ruby_version => ruby_version, :command => command).run!
      end
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do |file|
       run! @global_commands
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
           run! @global_commands
           @sent_an_int = false 
        end       
      end      
    end
    
  end
end