module InfinityTest
  module TestLibrary
    class Bacon < TestFramework
      
      parse_results :specifications => /(\d+) specifications/, :requirements => /(\d+) requirements/, :failures => /(\d+) failure/, :errors => /(\d+) errors/
      
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
      # 
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
            results[ruby_version] = "rvm #{ruby_version} ruby #{bacon_binary} -Ilib -d #{decide_files(file)}"
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
            
      def sucess?
        return false if failure?
        true
      end
      
      def failure?
        @failures > 0
      end
      
    end    
  end
end
