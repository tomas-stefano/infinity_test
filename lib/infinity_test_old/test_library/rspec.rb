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
      
      # First, try to find the rspec two binary
      # If don't find the rspec two, try to find the rspec one
      #
      def binary_search(environment)
        search_rspec_two(environment) || search_rspec_one(environment)
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
