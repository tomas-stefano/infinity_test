module InfinityTest
  class ContinuousTesting
    attr_accessor :application, :watchr, :global_commands
    
    def initialize
      @application = InfinityTest.application
      @watchr = InfinityTest.watchr
    end
    
    # Start the Continuous Testing Server and begin to audit the files for changes
    #
    def start!
      @global_commands = @application.construct_commands
      run!(@global_commands)
      initialize_watchr!
    end

    def run!(commands)
      @application.run!(commands) unless commands.empty?
    end

    ##################
    # Watchr Methods #
    ##################
    
    def initialize_watchr!
      @application.add_heuristics!
      @application.heuristics_users_high_priority!
      add_signal
      Watchr::Controller.new(@watchr, Watchr.handler.new).run
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