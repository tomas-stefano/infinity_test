require 'spec_helper'

module InfinityTest
  describe Rspec do
    
    it "should be possible to sett all rubies" do
      Rspec.new(:rubies => '1.9.1').rubies.should be == '1.9.1'
    end
    
    it "should set the rubies" do
      Rspec.new(:rubies => 'jruby,ree').rubies.should be == 'jruby,ree'
    end
    
    it "should have the pattern for spec directory" do
      Rspec.new.test_directory_pattern.should be == "^spec/(.*)_spec.rb"
    end
    
  end
end