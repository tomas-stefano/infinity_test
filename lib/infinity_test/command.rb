module InfinityTest
  class Command
    attr_accessor :command, :results, :line, :ruby_version

    # Create new Command object that receive the ruby_version and the command string
    #
    def initialize(options={})
      @command = options[:command]
      @ruby_version = options[:ruby_version]
      @current_ruby_string = RVM::Environment.current_ruby_string
      @results = []
      @line = []
    end

    # Code taken in Autotest gem and change a little
    #
    def run!
      old_sync = $stdout.sync
      $stdout.sync = true
      begin
        open("| #{@command}", "r") do |file|
          until file.eof? do
            test_line = file.getc or break
            if yarv?
              print(test_line)
            else
              putc(test_line)
            end
            @line.push(test_line)
            push_in_the_results(test_line)
          end
        end
      rescue Errno::ENOENT => e
        puts
        puts "\e[31m", "Error to build this command. Maybe is a RVM bug with non-shell commands or InfinityTest bug. :( Please create a issue in infinity test repo with the following message:", "\e[0m"
        puts
        puts e.message
        puts
      ensure
        $stdout.sync = old_sync
      end
      @results = @results.join
      self
    end

    # Push in the results the test line
    # If have in the Ruby Enterpise Edition or Ruby 1.8.* pack the numbers returned.
    # Join otherwise.
    #
    def push_in_the_results(test_line)
      if test_line == ?\n
        @results.push(yarv? ? @line.join : @line.pack('c*'))
        @line.clear
      end
    end

    # Using yarv?
    #
    def yarv?
      @current_ruby_string =~ /ruby-1.9/
    end

  end
end
