begin
  require 'rubygems'
rescue LoadError
  $stdout.puts("Appears that you don't have rubygems installed. Sorry, the infinity_test depends that. If you don't use the rubygems please help me to remove the rubygems dependency.")
  exit
end

infinity_test_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(infinity_test_directory) unless $LOAD_PATH.include?(infinity_test_directory)
require 'infinity_test'

include InfinityTest::BinaryPath

print rspec_path