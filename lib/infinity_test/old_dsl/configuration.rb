module InfinityTest
  module OldDSL
    class Configuration
      # Pass the responsability to InfinityTest::Base class. 
      #
      # <b>Don't need #super or #respond_to here.</b>
      # <b>This class will be removed in infinity_test 2.0.1</b>
      #
      def method_missing(method_name, *arguments, &block)
        InfinityTest::Base.send(method_name, *arguments, &block)
      end
    end

    module InfinityTestMethod
      # <b>DEPRECATED:</b> Please use <tt>InfinityTest::Base.setup</tt> instead.
      #
      def infinity_test(&block)
        message = "infinity_test method is deprecated. Use InfinityTest.setup { |config| ... } instead."
        ActiveSupport::Deprecation.warn(message)
        Configuration.new.instance_eval(&block)
      end
    end
  end
end

include InfinityTest::OldDSL::InfinityTestMethod