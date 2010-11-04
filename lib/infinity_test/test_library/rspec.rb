module InfinityTest
  module TestLibrary  
    class Rspec < TestFramework
      binary :rspec, :name => :rspec_two
      binary :spec,  :name => :rspec_one
      
      parse_results :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/
      
      #
      # rspec = InfinityTest::Rspec.new(:rubies => '1.9.1,1.9.2')
      # rspec.rubies # => '1.9.1,1.9.2'
      # rspec.test_pattern # => 'spec/**/*_spec.rb'
      #
      def initialize(options={})
        super(options)
        @test_pattern = 'spec/**/*_spec.rb'
      end
      
      # Construct all the commands for each ruby
      # First, try to find the rspec one binary, and if don't have installed 
      # try to find rspec two, and raise/puts an Error if don't find it.
      # After that, verifying if the user have a Gemfile, and if has, 
      # run with "bundle exec" command, else will run normally
      #
      def construct_rubies_commands(file=nil)
        commands = {}
        environments do |environment, ruby_version|
          rspec_binary = search_rspec_two(environment)
          rspec_binary = search_rspec_one(environment) unless have_binary?(rspec_binary)
          commands[ruby_version] = construct_command(
                                      :for => ruby_version, 
                                      :binary => rspec_binary, 
                                      :file => file, 
                                      :environment => environment)
        end
        commands
      end
      
      def search_files(file_pattern)
        all_files.grep(/#{file_pattern}/i).join(' ')
      end
      
      def sucess?
        return false if failure? or pending?
        true
      end
      
      def failure?
        @failures > 0
      end
      
      def pending?
        @pending > 0 and not failure?
      end
      
    end
  end
end