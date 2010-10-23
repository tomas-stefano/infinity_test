module InfinityTest
  module BinaryPath
    
    def self.included(base)
      base.extend ClassMethods
      base.send :include, ClassMethods
    end
    
    def rvm_bin_path(environment, binary)
      environment.path_for(binary)
    end
    
    def print_message(gem_name, ruby_version)
      puts "\n Ruby => #{ruby_version}:  I searched the #{gem_name} binary path and I don't find nothing. You have the #{gem_name} installed in this version?"
    end
    
    def search_binary(binary_name, options)
      rvm_bin_path(options[:environment], binary_name)
    end
    
    def have_binary?(binary)
      File.exist?(binary)
    end
    
    module ClassMethods
      
      # Set the binary to search in the RVM binary folder
      #
      # binary :bundle
      #
      def binary(binary_name, options={})
        method_sufix = options[:name] || binary_name
        eval <<-EVAL
          def search_#{method_sufix}(environment)
            search_binary('#{binary_name}', :environment => environment)
          end
        EVAL
      end

    end
    
  end
end