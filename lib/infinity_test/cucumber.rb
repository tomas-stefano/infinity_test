module InfinityTest
  class Cucumber
    include BinaryPath
    
    def build_command_string(ruby_versions=[])
      cucumber_binary_path = bin_path('cucumber', 'cucumber')
      unless ruby_versions.empty?
        "rvm #{ruby_versions.join(',')} ruby #{cucumber_binary_path}"
      else
        "ruby #{cucumber_binary_path}"
      end
    end
    
  end
end