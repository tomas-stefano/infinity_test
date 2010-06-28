module InfinityTest
  class Rspec
    include BinaryPath
    
    def build_command_string(rvm_versions)
      rspec_binary_path = bin_path('rspec', 'spec') # Rspec 1.3.0
      if rvm_versions
        "rvm #{rvm_versions} ruby #{rspec_binary_path} spec"
      else
        "ruby #{rspec_binary_path} spec"
      end
    end
    
  end
end