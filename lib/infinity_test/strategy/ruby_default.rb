module InfinityTest
  module Strategy
    class RubyDefault < Base
      def run!
      end

      # ==== Returns
      #  TrueClass: If the user don't pass the ruby versions to run tests.
      #  FalseClass: If the user pass some ruby version to run tests.
      #
      def self.run?
        Core::Base.rubies.blank?
      end

      # The Ruby Default should have the high priority to the auto discover find it first
      #
      def self.priority
        :high
      end
    end
  end
end