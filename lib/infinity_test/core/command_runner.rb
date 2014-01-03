module InfinityTest
  module Core
    class CommandRunner < String
      attr_accessor :command

      def initialize(command)
        @command = command

        super(run!)
      end

      def run!
        SynchronizeStdout.new do
          open("| #{@command}", "r") do |file|
            @command_output = CommandOutput.new(file)
            @command_output.puts
          end
        end

        @command_output.stdout
      end
    end

    class CommandOutput
      def initialize(file)
        @file    = file
        @results = []
        @line    = []
      end

      def puts
        until @file.eof? do
          test_line = @file.getc or break
          print(test_line)
          @line.push(test_line)
          if test_line == ?\n
            # @results.push(yarv? ? @line.join : @line.pack('c*'))
            @results.push(@line.join)
            @line.clear
          end
        end
      end

      def stdout
        @results.join
      end
    end

    class SynchronizeStdout
      def initialize
        old_sync     = $stdout.sync
        $stdout.sync = true

        begin
          yield
        ensure
          $stdout.sync = old_sync
        end
      end
    end
  end
end