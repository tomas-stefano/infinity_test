module InfinityTest
  class ApplicationFile
    
    def initialize(options)
      @test_framework = options[:test]
      @options = options
    end
    
    # Return the files that match by the options
    # This very used in the #run method called in the heuristics instances
    #
    # Example:
    #
    #  search(:all => :files) # => Return all test files
    #  search(:all => :files, :in_dir => :models) # => Return all the test files in the models directory
    #  search(:test_for => match_data)  # => Return the tests that match with the MatchData Object
    #  search(:test_for => match_data, :in_dir => :controllers) # => Return the tests that match with the MatchData Object
    #  search(match_data) # => return the test file
    #
    def search(options)
      result = case options
      when MatchData
        options.to_s
      when Hash
        if options.include?(:all)
          option_search_all(options).join(' ')
        else
          search_file_with_pattern(:pattern => options[:test_for][1], :in_dir => options[:in_dir])
        end
      end
    end
    
    # Search all test files in a dir specified or
    # return all test files
    #
    def option_search_all(options)
      if(directory = options[:in_dir])
        search_in(:directory => directory, :for_files => search_all_files)
      else
        search_all_files
      end
    end
    
    def search_file_with_pattern(options)
      files = search_all_files.grep(/#{options[:pattern]}/i)
      search_in(:directory => options[:in_dir], :for_files => files).join(' ')
    end
    
    def search_all_files
      @test_framework.all_files
    end
    
    # Search a file in the directory specified
    #
    def search_in(options)
      files = options[:for_files]
      directory = options[:directory]
      if directory
        dir_files = files_in_directory(directory)
        files.select { |file| dir_files.include?(file) }
      else
        files
      end
    end
    
    def files_in_directory(directory)
      case directory
      when Symbol
        Dir["*/#{directory}/*"]
      when Array
        directory.collect { |dir| files_in_directory(dir)}.flatten
      else
        Dir["#{directory}/*"]
      end
    end

  end
end