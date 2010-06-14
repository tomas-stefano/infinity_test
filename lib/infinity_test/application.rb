module InfinityTest
  class Application
    attr_accessor :styles
    
    def initialize
      @styles = []
    end
    
    def run!(args)
      arguments = args.clone
      arguments.each do |argument|
        argument = argument.gsub('--', '')
        load_cucumber_style if argument == 'cucumber'
        load_rspec_style if argument == 'rspec'
      end
    end
    
    def load_cucumber_style
      say "Style: Cucumber"
    end
    
    def load_rspec_style
      say "Style: Rspec"
    end
    
    def say(something)
      $stdout.puts(something)
    end
    
  end
end