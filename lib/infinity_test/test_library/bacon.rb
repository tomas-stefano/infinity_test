module InfinityTest
  module TestLibrary
    class Bacon < TestFramework
      include BinaryPath
      
      binary :bacon
      parse_results :specifications => /(\d+) specifications/, :requirements => /(\d+) requirements/, :failures => /(\d+) failure/, :errors => /(\d+) errors/
      
      # Bacon Framework
      #
      # For more information about the Bacon see: http://github.com/chneukirchen/bacon
      #
      # bacon = InfinityTest::Bacon.new(:rubies => '1.9.1,1.9.2')
      # bacon.rubies # => '1.9.1,1.9.2'
      # bacon.test_directory_pattern # => "^spec/*/(.*)_spec.rb"
      # bacon.test_pattern # => 'spec/**/*_spec.rb'
      # 
      def initialize(options={})
        super(options)
        @test_pattern = options[:test_pattern] || 'spec/**/*_spec.rb'
      end
      
      # Construct all the commands for each ruby
      # First, try to find the bacon binary, and raise/puts an Error if don't find it.
      # After that, verifying if the user have a Gemfile, and if has, run with "bundle exec" command, else will run normally
      #
      def construct_rubies_commands(file=nil)
        commands = {}
        environments do |environment, ruby_version|
          bacon_binary = search_bacon(environment)
          command = construct_command(:for => ruby_version, :binary => bacon_binary, :load_path => 'lib:spec', :file => file, :environment => environment) || next
          commands[ruby_version] = command
        end
        commands
      end
            
      def sucess?
        return false if failure?
        true
      end
      
      def failure?
        @failures > 0
      end
      
      def pending?
        false # Don't have pending in Bacon
      end
      
    end    
  end
end
