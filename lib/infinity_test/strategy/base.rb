module InfinityTest
  module Strategy
    class Base
      attr_accessor :base, :strategy

      delegate :rubies, :specific_options, :test_framework, :gemset, :bundler, :to => :base

      def initialize(base)
        @base = base
        @strategy = base.strategy
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

      # Returns the classes that need to be discover by the priority.
      #
      # ==== Options/Priorities
      #  * high
      #  * normal
      #  * regular
      #  * very_low
      #
      # ==== Returns
      # Array[Class]
      #
      def self.sort_by_priority
        subclasses.sort_by { |klass| klass.priority }
      end

      # Return the priority to be auto discover. 
      # If you want to your subclass to be high add this method and put other priority.
      # See InfinityTest::Strategy::Base.sort_by_priority for more information.
      #
      # ==== Returns
      #  Symbol: Defaults to middle priority
      #
      def self.priority
        :normal
      end

      # Return the strategy name base on the self class
      #
      def self.strategy_name
        self.name.demodulize.underscore.to_sym
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