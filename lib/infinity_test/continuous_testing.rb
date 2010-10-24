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
      @application.run_before_environment_callback!
      @global_commands = @application.construct_commands
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
      # add_rule script, :rule => @application.library_directory_pattern
      watch_lib_folder(@watchr, @application.library_directory_pattern)
      watch_app_falder(@watchr, @application.app_directory_pattern) if @application.app_directory_pattern
      add_rule @watchr, :rule => @application.test_directory_pattern
      add_signal
      Watchr::Controller.new(@watchr, Watchr.handler.new).run
    end
    
    def watch_lib_folder(script, library_directory_pattern)
      script.watch(library_directory_pattern) do |file|
        @application.run_changed_lib_file(file)
      end
    end
    
    def watch_app_falder(script, app_directory_patterns)
      app_directory_patterns.each do |directory|
        script.watch(directory) do |file|
          @application.run_changed_app_file(file)
        end
      end
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do |file|
        @application.run_changed_test_file(file)
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