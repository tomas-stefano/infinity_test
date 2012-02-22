require 'infinity_test/framework/rubygems'
require 'infinity_test/framework/rails'
require 'infinity_test/framework/padrino'

module InfinityTest
  module Framework
    class AutoDiscover < Base
      # Find framework and reset the framework to base and run heuristics again.
      #
      def heuristics
        @base.framework = find_framework
        @base.add_heuristics
      end

      # AutoDiscover doesn't add heuristics, just discover the right framework.
      #
      def self.run?
        false
      end

      def find_framework
        framework = Base.subclasses.find { |subclass| subclass.run? }
        if framework.present?
          framework.framework_name
        else
          message = <<-MESSAGE

            The InfinityTest::Framework::AutoDiscover doesn't discover nothing to run.
            Are you using a framework know by the InfinityTest?

          MESSAGE
          raise Exception, message
        end
      end
    end
  end
end