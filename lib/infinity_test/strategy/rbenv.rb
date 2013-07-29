module InfinityTest
  module Strategy
    class Rbenv < Base
      def run!
      end

      # ==== Returns
      #  TrueClass:  If the user had the rbenv installed.
      #  FalseClass: If the user don't had the rbenv installed.
      #
      def self.run?
        File.exist?(File.expand_path('~/.rbenv'))
      end
    end
  end
end