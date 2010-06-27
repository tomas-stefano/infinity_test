module InfinityTest
  class Cucumber
    include BinaryPath
    
    def build_command_string(ruby_versions=[])
      cucumber_binary_path = bin_path('cucumber', 'cucumber')
      unless ruby_versions.empty?
        "rvm 1.8.7,1.9.1 ruby #{cucumber_binary_path}"
      else
        "ruby #{cucumber_binary_path}"
      end
    end
    
  end
end