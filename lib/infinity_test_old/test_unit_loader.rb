#!/usr/bin/env ruby

# Load the test files from the command line.

ARGV.each { |file| load file unless file =~ /^-/  }
