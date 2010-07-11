module InfinityTest
  class Application
    attr_accessor :ruby_versions
    
    def resolve_ruby_versions(rvm_versions)
      @ruby_versions = rvm_versions
    end
    
    def load_cucumber_style
      say "Style: Cucumber"
      Cucumber.new.build_command_string(@ruby_versions)
    end
    
    def load_rspec_style
      say "Style: Rspec"
      Rspec.new.build_command_string(@ruby_versions)
    end
    
    def load_test_unit_style
      say "Style: Test::Unit"
      TestUnit.new.build_command_string(@ruby_versions)
    end
    
    def say(something)
      $stdout.puts(something)
    end
    
  end
end