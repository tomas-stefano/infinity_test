module InfinityTest
  class Application
    attr_accessor :styles, :ruby_versions
    
    def initialize
      @styles = []
      @ruby_versions = []
    end
    
    def resolve_ruby_versions(rvm_versions)
      rvm_versions.split(',').each do |version|
        @ruby_versions.push(version)
      end
    end
    
    def load_cucumber_style
      say "Style: Cucumber"
      cucumber = Cucumber.new
      command = cucumber.build_command_string(@ruby_versions)
      say command
      system(command)
    end
    
    def load_rspec_style
      say "Style: Rspec"
      rspec = Rspec.new
      command = rspec.build_command_string(@ruby_versions)
      say command
      system(command)    
    end
    
    def say(something)
      $stdout.puts(something)
    end
    
  end
end