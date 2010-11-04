module InfinityTest
  module TestLibrary
    class TestUnit < TestFramework
      parse_results :tests => /(\d+) tests/, :assertions => /(\d+) assertions/, 
                    :failures => /(\d+) failures/, :errors => /(\d+) errors/

      def initialize(options={})
        super(options)
        @test_pattern = 'test/**/*_test.rb'
      end
      
      def construct_rubies_commands(file=nil)   
        command = {}
        environments do |environment, ruby_version|
          command[ruby_version] = construct_command(
                                  :for => ruby_version, 
                                  :load_path => 'lib:test', 
                                  :file => file, 
                                  :environment => environment, 
                                  :skip_binary? => true)
        end
        command
      end
      
      def test_files
        super.split.unshift(test_loader).join(' ')
      end
    
      def test_loader
        $LOAD_PATH.each do |path|
          file_path = File.join(path, "infinity_test/test_unit_loader.rb")    
          return file_path if File.exist?(file_path)
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