module InfinityTest
  class Rails
    attr_accessor :test_framework

    def initialize(options)
      @test_framework=options[:test_framework]
    end


    def app_watch_path
      ["^app/*/(.*)\.rb", "^app/views/(.*)"]
    end

    #Map the test files when rails file is changed and Return the map files
    #
    def map_file(file)
      filename=File.basename(file,".rb")
      case file
      when %r%^app/models/(.*)\.rb$%
       ["spec/models/#{filename}_spec.rb"]
      when %r%^app/controllers/(.*)\.rb$%
       ["spec/controllers/#{filename}_controller_spec.rb"]
      end
    end
    
  end
end
