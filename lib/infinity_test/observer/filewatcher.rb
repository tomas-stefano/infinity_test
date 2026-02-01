require 'filewatcher'

module InfinityTest
  module Observer
    class Filewatcher < Base
      attr_reader :observer, :watch_paths, :patterns

      def initialize(continuous_test_server)
        super
        @watch_paths = []
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
        path = "#{dir_name}/**/*.#{extension}"
        @watch_paths << path unless @watch_paths.include?(path)
      end

      # Start the continuous test server.
      #
      def start
        paths = @watch_paths.empty? ? ['**/*.rb'] : @watch_paths

        @observer = ::Filewatcher.new(paths)

        @observer.watch do |changes|
          changes.each do |file_path, _event|
            relative_path = file_path.sub("#{Dir.pwd}/", '')
            handle_file_change(relative_path)
          end
        end
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
