

# TODO: Make require with System Wide Install too
#
rvm_library_directory = File.expand_path("~/.rvm/lib")
$LOAD_PATH.unshift(rvm_library_directory) unless $LOAD_PATH.include?(rvm_library_directory)
require 'rvm'

require 'watchr'
require 'ostruct'

