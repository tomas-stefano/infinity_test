module InfinityTest
  module Callbacks
    class BaseCallback
      attr_accessor :scope, :block

      def initialize(scope, &block)
        @scope = scope
        @block = block
      end
    end
  end
end