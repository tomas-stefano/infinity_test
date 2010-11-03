
RVM_LIBRARY_DIRECTORY = File.expand_path("~/.rvm/lib")

#
# Try to require the rvm in home folder
# If not suceed raise a LoadError 
# Try to see if the user has the RVM 1.0 or higher for the RVM Ruby API
# If not raise a NameError
#
def require_home_rvm
  $LOAD_PATH.unshift(RVM_LIBRARY_DIRECTORY) unless $LOAD_PATH.include?(RVM_LIBRARY_DIRECTORY)
  require 'rvm'
  RVM::Environment
end

# TODO: Make require with System Wide Install too
#
begin
  require_home_rvm
rescue LoadError, NameError
  puts
  puts "It appears that you have not installed the RVM in #{RVM_LIBRARY_DIRECTORY} or RVM is very old.\n"
  puts "The RVM is installed?"
  puts "If not, please see http://rvm.beginrescueend.com/rvm/install/"
  puts "If so, try to run:"
  puts "\t rvm update --head (or if you're using the head of rvm try: rvm get head)"
  puts "If the error continues, please create an issue in http://github.com/tomas-stefano/infinity_test"
  puts 'Thanks :)'
  exit
end

def require_without_rubygems(options)
  gem_name = options[:gem]
  begin
    require gem_name
  rescue LoadError
    require 'rubygems'
    require gem_name
  end
end

require_without_rubygems :gem => 'watchr'
require_without_rubygems :gem => 'notifiers'

require 'ostruct'

