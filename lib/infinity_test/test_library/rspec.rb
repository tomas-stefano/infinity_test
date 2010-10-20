module InfinityTest
  module TestLibrary  
    class Rspec < TestFramework

      include BinaryPath
      attr_accessor :rubies, :test_directory_pattern, :message, :test_pattern, 
                    :failure, :sucess, :pending
      
      parse_results :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/

      #
      # rspec = InfinityTest::Rspec.new(:rubies => '1.9.1,1.9.2')
      # rspec.rubies # => '1.9.1,1.9.2'
      #
      def initialize(options={})
        @rubies = options[:rubies] || []
        @test_directory_pattern = "^spec/*/(.*)_spec.rb"
        @test_pattern = options[:test_pattern] || 'spec/**/*_spec.rb'
      end
      
      def construct_commands(file=nil)
        @rubies << RVM::Environment.current.environment_name if @rubies.empty?
        construct_rubies_commands(file)
      end
      
      def all_files
        Dir[@test_pattern]
      end
      
      def spec_files
        all_files.collect { |file| file }.join(' ')
      end
      
      def construct_rubies_commands(file=nil)
        results = Hash.new
        RVM.environments(@rubies) do |environment|
          ruby_version = environment.environment_name
          rspec_binary = search_rspec_two(environment)
          rspec_binary = search_rspec_one(environment) unless File.exist?(rspec_binary)
          unless have_binary?(rspec_binary)
            print_message('rspec', ruby_version)
          else
            results[ruby_version] = "rvm #{ruby_version} ruby #{rspec_binary} #{decide_files(file)}"
          end
        end
        results
      end
      
      # TODO: I'm not satisfied yet
      #
      def decide_files(file)
        return file if file
        spec_files
      end
      
      def search_rspec_two(environment)
        search_binary('rspec', :environment => environment)
      end
      
      def search_rspec_one(environment)
        search_binary('spec', :environment => environment)
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
      
      
      #For rails file change
      
    end
  end
end