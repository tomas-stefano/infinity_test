module InfinityTest
  module Core
    class AutoDiscover
      attr_reader :base

      def initialize(base)
        @base = base
      end

      def discover_libraries
        discover_strategy
        discover_framework
        discover_test_framework
      end

      def discover_strategy
        base.strategy = auto_discover(:strategy) if base.strategy.equal?(:auto_discover)
      end

      def discover_framework
        base.framework = auto_discover(:framework) if base.framework.equal?(:auto_discover)
      end

      def discover_test_framework
        base.test_framework = auto_discover(:test_framework) if base.test_framework.equal?(:auto_discover)
      end

      private

      def auto_discover(library_type)
        library_base_class = "InfinityTest::#{library_type.to_s.camelize}::Base".constantize
        library            = library_base_class.subclasses.find { |subclass| subclass.run? }

        if library.present?
          library.name.demodulize.underscore.to_sym
        else
          message = %{

            The InfinityTest::Core::AutoDiscover doesn't discover nothing to run.
            Are you using a #{library_type} that Infinity test knows?

            Infinity Test #{library_type.to_s.pluralize}: #{library_base_class.subclasses.each { |klass| klass }}

          }
          raise Exception, message
        end
      end
    end
  end
end