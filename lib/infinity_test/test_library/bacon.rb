module InfinityTest
  module TestLibrary
    class Bacon < TestFramework
      
      
      #
      # test_pattern = 'spec/**/*_spec.rb'
      #
      # files.to.test(Dir[test_pattern])
      #
      # watch :pattern => '^spec/*/(.*)_spec.rb'
      #
      # construct_commands do |environment|
      #   ruby_version = environment.environment_name
      #   bacon_binary = search_bacon(environment)
      #   unless have_binary?(bacon_binary)
      #     print_message('bacon', ruby_version)
      #   else
      #     results[ruby_version] = "rvm #{ruby_version} ruby #{bacon_binary} #{decide_files(file)}"
      #   end
      # end
      #
      # parse_results :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/
      #

      include BinaryPath
      attr_accessor :rubies, :test_directory_pattern, :message, :test_pattern, 
                    :failure, :sucess, :pending
      
      #
      # bacon = InfinityTest::Bacon.new(:rubies => '1.9.1,1.9.2')
      # bacon.rubies # => '1.9.1,1.9.2'
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
          bacon_binary = search_bacon(environment)
          unless have_binary?(bacon_binary)
            print_message('bacon', ruby_version)
          else
            results[ruby_version] = "rvm #{ruby_version} ruby #{bacon_binary} #{decide_files(file)}"
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
      
      def search_bacon(environment)
        search_binary('bacon', :environment => environment)
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
