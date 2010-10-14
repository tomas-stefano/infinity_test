module InfinityTest
  class Rails
    attr_accessor :test_framework,:test_mappings
   
    def initialize(options)
      @test_framework=options[:test_framework]
      @test_mappings=[]
    end

    
    def app_watch_path
      ["^app/*/(.*)\.rb", "^app/views/(.*)"]
    end


    def add_mapping(file)
      @test_mappings.push map_file(file)
    end
    
    private
    
    def map_file(file)
       file = File.basename(file)
    end
    
  end
end
