module InfinityTest
  module Strategy
    class Base
      attr_accessor :base, :strategy

      delegate :rubies, :specific_options, :test_framework, :gemset, :bundler, :to => :base

      def initialize(base)
        @base = base
        @strategy = base.strategy
      end

      # Return the strategy name base on the self class
      #
      def self.strategy_name
        self.name.demodulize.underscore.to_sym
      end

      # Everytime someone inherits from InfinityTest::Strategy::Base class, 
      # register the klass into baseclass.
      #
      def self.inherited(klass)
        subclasses.push(klass)
      end

      # Returns the classes that inherits from InfinityTest::Strategy::Base
      #
      # ==== Returns
      # Array[Class]
      #
      def self.subclasses
        @subclasses ||= []
      end

      # Obviously, this method is called for the InfinityTest when run the strategy
      #
      def run!
        raise NotImplementedError
      end

      # Put all the requires to autodiscover use your strategy instead of others.
      #
      def self.run?
        raise NotImplementedError
      end
    end
  end
end