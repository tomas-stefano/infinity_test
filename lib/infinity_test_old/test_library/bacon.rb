module InfinityTest
  module TestLibrary
    class Bacon < TestFramework
      binary :bacon
      alias :binary_search :search_bacon
      parse_results :specifications => /(\d+) specifications/, :requirements => /(\d+) requirements/, :failures => /(\d+) failure/, :errors => /(\d+) errors/

      attr_accessor :defaults

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
        @test_pattern = 'spec/**/*_spec.rb'
        @defaults = %{-I"lib:spec"}
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
