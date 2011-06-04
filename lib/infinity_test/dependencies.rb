module InfinityTest
  class Dependencies
    
    RVM_HOME_DIRECTORY = File.expand_path("~/.rvm/lib")
    
    RVM_SYSTEM_WIDE_DIRECTORY = "/usr/local/rvm/lib"
    
    RVM_LIBRARY_DIRECTORY = File.expand_path("~/.rvm/lib")

    class << self
      
      def require_rvm
        begin
          require_home_rvm
        rescue LoadError, NameError
          try_to_require_system_wide
        end
      end
      
      def require_rvm_ruby_api
        require 'rvm'
        RVM::Environment
      end
      
      #
      # Try to require the rvm in home folder
      # If not suceed raise a LoadError
      # Try to see if the user has the RVM 1.0 or higher for the RVM Ruby API
      # If not raise a NameError
      #
      def require_home_rvm
        $LOAD_PATH.unshift(RVM_HOME_DIRECTORY) unless $LOAD_PATH.include?(RVM_HOME_DIRECTORY)
        require_rvm_ruby_api
      end
      
      def require_rvm_system_wide
        $LOAD_PATH.unshift(RVM_SYSTEM_WIDE_DIRECTORY) unless $LOAD_PATH.include?(RVM_SYSTEM_WIDE_DIRECTORY)
        require_rvm_ruby_api
      end
      
      def try_to_require_system_wide
        begin
          require_rvm_system_wide
        rescue LoadError, NameError
          print_info_about_rvm
        end        
      end
      
      def require_without_rubygems(options)
        gem_name = options[:gem]
        begin
          require gem_name
        rescue LoadError
          require 'rubygems'
          require gem_name
        end
      end
      
      def print_info_about_rvm
        puts
        puts "It appears that you have not installed the RVM library in #{RVM_HOME_DIRECTORY} or in #{RVM_SYSTEM_WIDE_DIRECTORY} or RVM is very old.\n"
        puts "The RVM is installed?"
        puts "If not, please see http://rvm.beginrescueend.com/rvm/install/"
        puts "If so, try to run:"
        puts "\t rvm get head (if you're using an old rvm try: rvm update --head)"
        puts "\nIf the error continues, please create an issue in http://github.com/tomas-stefano/infinity_test"
        puts 'Thanks :)'
        puts
        exit        
      end
      
    end
  end

end

InfinityTest::Dependencies.require_rvm
InfinityTest::Dependencies.require_without_rubygems :gem => 'watchr'
InfinityTest::Dependencies.require_without_rubygems :gem => 'notifiers'