begin
  require 'watchr'
rescue LoadError
  require 'rubygems'
  require 'watchr'
end

module InfinityTest
  class ContinuousTesting
    attr_accessor :application
    
    def initialize(options)
      @application = options[:application]
      @test_framework = application.test_framework
      @cucumber = application.cucumber?
      @rubies = application.rubies
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
      main_command
      script = Watchr::Script.new
      add_rule script, :rule => library_directory_pattern
      add_rule script, :rule => test_directory_pattern
      add_signal
      Watchr::Controller.new(script, Watchr.handler.new).run
    end
    
    def main_command
      if @test_framework == :rspec
        commands = command_for_rspec
        commands.each do |command|
          puts
          puts(command)
          system(command)
        end
      end
    end
    
    def command_for_rspec
      file = File.expand_path(File.join(File.dirname(__FILE__), 'binary_path', 'rspec.rb'))
      results = []
      puts "* Grabbing the Rspec Path for each Ruby"
      unless @rubies.empty?
        RVM.environments(@application.rubies) do |environment|
          results << environment.ruby(file)
        end
        commands = results.collect { |result| result.stdout + ' spec' }
      else
        rspec = [Gem.bin_path('rspec-core', 'rspec') + ' spec']
      end
    end
    
    def add_rule(script, options={})
      script.watch(options[:rule]) do |file|
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