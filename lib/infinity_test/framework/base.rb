module InfinityTest
  module Framework
    class Base
      attr_accessor :base, :test_framework, :observer, :strategy
      delegate :watch, :watch_dir, :to => :observer

      def initialize(options={})
        @test_framework = options.fetch(:test_framework_instance)
        @observer       = options.fetch(:observer_instance)
        @strategy       = options.fetch(:strategy_instance)
      end

      # Everytime someone inherits from InfinityTest::Framework::Base class,
      # register the klass into baseclass.
      #
      def self.inherited(klass)
        subclasses.push(klass)
      end

      # Returns the classes that inherits from InfinityTest::Framework::Base
      #
      # ==== Returns
      # Array[Class]
      #
      def self.subclasses
        @subclasses ||= []
      end

      # Return the framework name base on the self class
      #
      def self.framework_name
        self.name.demodulize.underscore.to_sym
      end

      # This method is called for the InfinityTest before starting the observer
      #
      def heuristics
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your framework instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end