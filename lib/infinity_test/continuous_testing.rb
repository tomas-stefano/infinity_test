module InfinityTest
  class ContinuousTesting
    attr_accessor :application, :watchr, :global_commands
    
    def initialize
      @application = InfinityTest.application
      @watchr = InfinityTest.watchr
    end

    ##################
    # Watchr Methods #
    ##################
    
    def initialize_watchr!
      add_signal 
      run_with_watchr!
    end
    alias :start! :initialize_watchr!
    
    def run_with_watchr!
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
           @application.run_global_commands!
           @sent_an_int = false 
        end       
      end      
    end
    
  end
end