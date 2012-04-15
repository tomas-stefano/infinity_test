module InfinityTest
  module Strategy
    class Base
      attr_accessor :base, :test_framework

      delegate :rubies, :specific_options, :gemset, :bundler, :to => :base

      def initialize(base)
        @base = base
        @test_framework = base.test_framework_instance
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

      # ==== Returns
      #  @command: return command if don't find a Gemfile and if the Core::Base bundler is set to false
      #  @command with bundle exec: if find a Gemfile and if the Core::Base bundler is set to true
      def bundle_exec(command)
        if has_gemfile? and @base.using_bundler?
          "bundle exec #{command}"
        else
          command
        end
      end

      # ==== Returns
      # CommandBuilderClass: A class that builds that command using method_missing.
      #
      def command_builder
        Core::CommandBuilder.new
      end

      # ==== Returns
      # TrueClass: If Gemfile exists.
      # FalseClass: If Gemfile don't exists.
      #
      def has_gemfile?
        File.exist?(File.expand_path('./Gemfile'))
      end

      # Obviously, this method is called for the InfinityTest when run the strategy
      #
      def run!
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your strategy instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end