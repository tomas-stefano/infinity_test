module InfinityTest
  module Core
    class CommandBuilder < String
      def opt(command_option)
        self << " --#{command_option}"
        self
      end

      def option(command_option)
        self << " -#{command_option}"
        self
      end

      def respond_to?(method_name)
        true
      end

      def method_missing(method_name, *args, &block)
        if self.empty?
          self << "#{method_name.to_s}"
        else
          self << " #{method_name.to_s}"
        end
        self
      end
    end
  end
end