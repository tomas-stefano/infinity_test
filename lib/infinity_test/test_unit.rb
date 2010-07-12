module InfinityTest
  class TestUnit

    def build_command_string(ruby_versions)
      files = collect_test_files.unshift(test_loader).join(' ')
      ruby_string = "ruby -Ilib:test #{files}"
      unless ruby_versions
        ruby_string
      else
        "rvm #{ruby_versions} #{ruby_string}"
      end
    end
    
    def collect_test_files
      Dir['test/**/*_test.rb'].collect { |file| file }
    end

    def test_loader
      $LOAD_PATH.each do |path|
        file_path = File.join(path, "infinity_test/test_unit_loader.rb")    
        return file_path if File.exist?(file_path)
      end
    end
  end
end