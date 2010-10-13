module InfinityTest
  module TestLibrary  
    class Rspec
      include BinaryPath
      attr_accessor :rubies, :test_directory_pattern, :message, :test_pattern, 
                    :failure, :sucess, :pending
      
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
      
      def parse_results(results)
        shell_result = results.split("\n").last
        if shell_result =~ /example/
          @example = shell_result[/(\d+) example/, 1].to_i
          @failure = shell_result[/(\d+) failure/, 1].to_i
          @pending = shell_result[/(\d+) pending/, 1].to_i
          @message = "#{@example} examples, #{@failure} failures, #{@pending} pending"
        else
          @example, @pending, @failure = 0, 0, 1
          @message = "An exception occurred"
        end
      end
      
      def sucess?
        return false if failure? or pending?
        true
      end
      
      def failure?
        @failure > 0
      end
      
      def pending?
        @pending > 0 and not failure?
      end
      
    end
  end
end