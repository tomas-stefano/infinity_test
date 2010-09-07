begin
  require 'watchr'
rescue LoadError
  require 'rubygems'
  require 'watchr'
end

module InfinityTest
  class ContinuousTesting
    attr_accessor :application, :test_framework, :library_directory_pattern
    
    def initialize(options)
      @application = options[:application]
      @test_framework = @application.test_framework.equal?(:rspec) ? Rspec.new : TestUnit.new
      @library_directory_pattern = "^lib/(.*)\.rb"
      @commands = @test_framework.construct_commands
    end
    
    def start!      
      run! @commands
      initialize_watchr!
    end
    
    def initialize_watchr!
      script = Watchr::Script.new
      add_rule script, :rule => library_directory_pattern
      add_rule script, :rule => @test_framework.test_directory_pattern
      add_signal
      Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def run!(commands)
      commands.each do |ruby_version, command|
        puts "* Using #{ruby_version}"
        puts command
        system(command)
      end
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do |file|
       run! @commands
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