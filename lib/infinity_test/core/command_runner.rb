require 'pty'

module InfinityTest
  module Core
    class CommandRunner < String
      attr_accessor :command

      def initialize(command)
        @command = command

        super(run!)
      end

      def run!
        output = []
        old_sync = $stdout.sync
        $stdout.sync = true

        begin
          PTY.spawn(@command) do |stdout, _stdin, _pid|
            stdout.each_char do |char|
              print char
              output << char
            end
          end
        rescue PTY::ChildExited
          # Command finished
        rescue Errno::EIO
          # End of output
        ensure
          $stdout.sync = old_sync
        end

        output.join
      end
    end
  end
end