module InfinityTest
  module Framework
    class Padrino < Base
      def heuristics
      end

      # ==== Returns
      #  TrueClass: Find the config/apps.rb in the user current dir
      #  FalseClass: Don't Find the config/apps.rb in the user current dir
      #
      def self.run?
        File.exist?(File.expand_path('./config/apps.rb'))
      end
    end
  end
end