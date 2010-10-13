module InfinityTest
  module TestLibrary
    class TestUnit
      attr_reader :rubies, :message, :test_directory_pattern, :tests, 
                  :assertions, :failures, :errors
      
      def initialize(options={})
        @rubies = options[:rubies] || []
        @test_directory_pattern = "^test/*/(.*)_test.rb"
        @test_pattern = 'test/**/*_test.rb'
      end
      
      def construct_commands(file=nil)
        @rubies << RVM::Environment.current.environment_name if @rubies.empty?
        construct_rubies_commands(file)
      end
      
      def construct_rubies_commands(file=nil)
        results = Hash.new
        RVM.environments(@rubies) do |environment|
          ruby_version = environment.environment_name
          results[ruby_version] = "rvm #{ruby_version} ruby -I'lib:test' #{decide_files(file)}"
        end
        results
      end
      
      def decide_files(file)
        return file if file
        test_files
      end
      
      def test_files
        collect_test_files.unshift(test_loader).join(' ')
      end
    
      def collect_test_files
        all_files.collect { |file| file }
      end
      
      def all_files
        Dir[@test_pattern]
      end
    
      def test_loader
        $LOAD_PATH.each do |path|
          file_path = File.join(path, "infinity_test/test_unit_loader.rb")    
          return file_path if File.exist?(file_path)
        end
      end
      
      def parse_results(results)
        shell_result = results.split("\n")
        shell_result = shell_result.select { |line| line =~ /(\d+) tests/}.first
        if shell_result
          @tests    = shell_result[/(\d+) tests/, 1].to_i
          @assertions = shell_result[/(\d+) assertions/, 1].to_i
          @failures = shell_result[/(\d+) failures/, 1].to_i
          @errors   = shell_result[/(\d+) errors/, 1].to_i
          @message = shell_result
        else
          @tests, @assertions, @failures, @errors = 0, 0, 1, 1
          @message = "An exception ocurred"
        end
      end
      
      def failure?
        @failures > 0 or @errors > 0
      end
      
      def pending?
        false # Don't have pending in Test::Unit right?? #doubt
      end
    
    end
  end
end