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
        run! commands_for_rspec        
      else
        run! commands_for_test_unit
      end
    end
    
    def run!(commands)
      commands.each do |ruby_version, command|
        puts "* Using #{ruby_version}"
        puts command
        system(command)
      end
    end
    
    def commands_for_rspec
      file = File.expand_path(File.join(File.dirname(__FILE__), 'binary_path', 'rspec.rb'))
      results = {}
      unless @rubies.empty?
        puts "* Grabbing the Rspec Path for each Ruby"
        RVM.environments(@application.rubies) do |environment|
          results[environment.environment_name] = environment.ruby(file).stdout + ' spec'
        end
        results
      else
        rspec = { RUBY_VERSION => "#{Gem.bin_path('rspec-core', 'rspec') + ' spec'}" }
      end
    end
    
    def commands_for_test_unit
      { RUBY_VERSION => InfinityTest::TestUnit.new.build_command_string(@rubies) }
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