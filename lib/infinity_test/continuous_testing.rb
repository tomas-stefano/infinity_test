module InfinityTest
  class ContinuousTesting
    attr_accessor :application, :global_commands
    
    def initialize(options)
      @application = options[:application]
      @global_commands = @application.construct_commands
    end
    
    # Start the Continuous Testing Server and begin to audit the files for changes
    #
    def start!
      run!(@global_commands)
      initialize_watchr!
    end

    def run!(commands)
      @application.run!(commands) unless commands.empty?
    end

    ##################
    # Watchr Methods #
    #################
    
    def initialize_watchr!
      script = Watchr::Script.new
      add_rule script, :rule => @application.library_directory_pattern
      add_rule script, :rule => @application.test_directory_pattern
      add_signal
      Watchr::Controller.new(script, Watchr.handler.new).run
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