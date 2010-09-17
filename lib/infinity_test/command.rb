module InfinityTest
  class Command
    attr_accessor :command, :results, :line, :ruby_version
    
    # Create new Command object that receive the ruby_version and the command string
    #
    def initialize(options={})
      @command = options[:command]
      @ruby_version = options[:ruby_version]
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
            test_line = file.getc 
            break unless test_line
            putc(test_line)
            @line.push(test_line)
            push_in_the_results(test_line)
          end
        end
      ensure
        $stdout.sync = old_sync
      end
      @results = @results.join
      self
    end

    # Push in the results the test line
    # If have in the Ruby Enterpise Edition pack the numbers return. Join otherwise.
    #
    def push_in_the_results(test_line)
      if end_of_line?(test_line)
        @results.push(ree? ? @line.pack('c*') : @line.join)
        @line.clear
      end
    end
    
    # Using Ruby Enterprise Edition?
    #
    def ree?
      RVM::Environment.current_ruby_string =~ /ree/
    end
    
    def end_of_line?(test_line)
      test_line == ?\n
    end
    
  end
end