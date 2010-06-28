module InfinityTest
  class Cucumber
    include BinaryPath
    
    def build_command_string(ruby_versions)
      cucumber_binary_path = bin_path('cucumber', 'cucumber')
      if ruby_versions
        "rvm #{ruby_versions} ruby #{cucumber_binary_path}"
      else
        "ruby #{cucumber_binary_path}"
      end
    end
    
  end
end