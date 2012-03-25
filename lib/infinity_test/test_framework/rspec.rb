module InfinityTest
  module TestFramework
    class Rspec < Base

      def test_dir
        'spec'
      end

      def test_helper_file
        File.join("#{test_dir}", "spec_helper.rb")
      end

      def test_files
        []
      end
    end
  end
end