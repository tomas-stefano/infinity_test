require 'listen'

module InfinityTest
  module Observer
    class Listen < Base
      attr_reader :observer, :directories, :patterns

      def initialize(continuous_test_server)
        super
        @directories = []
        @patterns = {}
      end

      # Watch a file or pattern for changes.
      #
      # ==== Examples
      #
      #   watch('lib/(.*)\.rb') { |file| puts [file.name, file.path, file.match_data] }
      #   watch('test/test_helper.rb') { run_all() }
      #
      def watch(pattern_or_file, &block)
        pattern = Regexp.new(pattern_or_file.to_s)
        @patterns[pattern] = block
      end

      # Watch a directory for changes.
      #
      # ==== Examples
      #
      #   watch_dir(:lib)  { |file| run_test(file) }
      #   watch_dir(:test) { |file| run_file(file) }
      #
      #   watch_dir(:test, :py) { |file| puts [file.name, file.path, file.match_data] }
      #   watch_dir(:test, :js) { |file| puts [file.name, file.path, file.match_data] }
      #
      def watch_dir(dir_name, extension = :rb, &block)
        watch("^#{dir_name}/*/(.*).#{extension}", &block)
        @directories << dir_name.to_s unless @directories.include?(dir_name.to_s)
      end

      # Start the continuous test server.
      #
      def start
        dirs = @directories.empty? ? ['.'] : @directories
        dirs = dirs.select { |d| File.directory?(d) }
        dirs = ['.'] if dirs.empty?

        @observer = ::Listen.to(*dirs) do |modified, added, _removed|
          (modified + added).each do |file|
            relative_path = file.sub("#{Dir.pwd}/", '')
            handle_file_change(relative_path)
          end
        end

        @observer.start
        sleep
      rescue Interrupt
        @observer.stop if @observer
      end

      private

      def handle_file_change(file_path)
        @patterns.each do |pattern, block|
          if match_data = pattern.match(file_path)
            changed_file = InfinityTest::Core::ChangedFile.new(match_data)
            block.call(changed_file)
            break
          end
        end
      end
    end
  end
end
