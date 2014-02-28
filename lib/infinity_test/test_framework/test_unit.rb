module InfinityTest
  module TestFramework
    class TestUnit < Base
      def test_dir
        'test'
      end

      def test_helper_file
        File.join(test_dir, 'test_helper.rb')
      end

      def binary
        ''
      end
    end
  end
end