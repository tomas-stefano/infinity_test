module InfinityTest
  class TestUnit

    def build_command_string(ruby_versions)
      files = Dir['test/**/*_test.rb'].collect { |file| file }
      files.unshift(test_loader)
      "ruby -Ilib:test #{files.join(' ')}" unless files.empty?
    end
    
    def test_loader
      $LOAD_PATH.each do |path|
        file_path = File.join(path, "infinity_test/test_unit_loader.rb")    
        return file_path if File.exist?(file_path)
      end
    end
  end
end