module InfinityTest
  class ApplicationFile
    
    def initialize(options)
      @test_framework = options[:test]
      @app_framework = options[:app]
      @options = options
    end
    
    def search(options)
      if options.include?(:all)
        if(directory = options[:in_dir])
          search_in_directory(directory)
        else
          search_all_files
        end
      end
    end
    
    def search_all_files
      @test_framework.all_files
    end
    
    def search_in_directory(directory)
      dir_files = files_in_directory(directory)
      search_all_files.select { |file| dir_files.include?(file) }
    end
    
    def files_in_directory(directory)
      if directory.is_a?(Symbol)
        Dir["*/#{directory}/*"]
      else
        Dir["#{directory}/*"]
      end
    end

  end
end