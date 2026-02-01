module InfinityTest
  module Core
    class Callback
      attr_reader :scope, :block, :type

      VALID_SCOPES = [:all, :each_ruby].freeze

      # Create a new callback
      #
      # @param type [Symbol] :before or :after
      # @param scope [Symbol] :all or :each_ruby (defaults to :all)
      # @param block [Proc] The block to execute
      #
      def initialize(type, scope = :all, &block)
        @type  = type
        @scope = scope || :all
        @block = block

        validate_scope!
      end

      # Execute the callback block
      #
      # @param environment [Hash] Optional environment info passed to the block
      #
      def call(environment = nil)
        if block.arity > 0
          block.call(environment)
        else
          block.call
        end
      end

      def before?
        type == :before
      end

      def after?
        type == :after
      end

      def all?
        scope == :all
      end

      def each_ruby?
        scope == :each_ruby
      end

      private

      def validate_scope!
        unless VALID_SCOPES.include?(scope)
          raise ArgumentError, "Invalid callback scope: #{scope}. Valid scopes are: #{VALID_SCOPES.join(', ')}"
        end
      end
    end
  end
end
