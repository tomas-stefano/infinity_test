require 'thor'

module InfinityTest
  class CommandLine < Thor
    default_task :runner
        
    desc("runner [OPTIONS]", <<-EODESC.gsub(/^\s{6}/, ""))
      Starts a continuous test server.

      Specify the Test library using in options:      
        --testunit : Test::Unit Library
        --rspec     : Rspec Framework
        --cucumber :  Cucumber Library
        
      Specify the Ruby Versions with:      
        --rvm-versions 1.8.6 1.8.7 1.8.9

    EODESC
    method_options :cucumber => :boolean, :rspec => :boolean
    method_option :rvm_versions, :type => :string, :alias => '--rvm-versions'    
    def runner
      application = InfinityTest.application
      application.resolve_ruby_versions(options[:rvm_versions]) if options[:rvm_versions]
      application.load_rspec_style if options[:rspec]
      application.load_cucumber_style if options[:cucumber]
    end
    
  end
end