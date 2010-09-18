module InfinityTest
  module BinaryPath
    
    def rvm_bin_path(environment, binary)
      "~/.rvm/gems/#{environment.expanded_name}/bin/#{binary}"
    end
    
    def print_message(gem_name, ruby_version)
      puts "\n Ruby => #{ruby_version}:  I searched the #{gem_name} binary path and I don't find nothing. You have the #{gem_name} installed in this version?"
    end
    
    def search_binary(binary_name, options)
      File.expand_path(rvm_bin_path(options[:environment], binary_name))
    end
    
    def have_binary?(binary)
      File.exist?(binary)
    end
    
  end
end