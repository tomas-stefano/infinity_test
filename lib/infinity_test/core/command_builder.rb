module InfinityTest
  module Core
    class CommandBuilder < String
      # Just Syntax Sugar to add the keyword in the command
      #
      def add(command)
        self << " #{command.to_s}"
        self
      end

      # Put a double-dash in the command option.
      #
      def opt(command_option)
        self << " --#{command_option}"
        self
      end

      # Put one dash in the command option
      #
      def option(command_option)
        self << " -#{command_option}"
        self
      end

      # An Object that respond to all methods.
      #
      def respond_to?(method_name)
        true
      end

      # Everytime will call a method will append to self.
      #
      # ==== Examples
      #
      #   command.bundle.exec.rspec.spec
      #   command.bundle.install
      #
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