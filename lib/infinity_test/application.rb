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
      cucumber.build_command_string(@ruby_versions)
    end
    
    def load_rspec_style
      say "Style: Rspec"
      rspec = Rspec.new
      rspec.build_command_string(@ruby_versions)
    end
    
    def say(something)
      $stdout.puts(something)
    end
    
  end
end