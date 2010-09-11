module InfinityTest
  class Command
    attr_accessor :command, :results, :line
    
    def initialize(options={})
      @command = options[:command]
      @results = []
      @line = []
    end
        
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
    
    def push_in_the_results(test_line)
      if end_of_line?(test_line) then
        @results << @line.join
        @line.clear
      end
    end
    
    def end_of_line?(test_line)
      test_line == ?\n
    end
    
  end
end