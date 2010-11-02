require 'spec_helper'

module InfinityTest
  module ApplicationLibrary
    describe RubyGems do
      let(:rubygems) { RubyGems.new }

      describe '#application' do
        it { rubygems.application.should equal InfinityTest.application }
      end

      describe '#lib_pattern' do

        it { rubygems.lib_pattern.should == "^lib/*/(.*)\.rb" }
        
        it "should be possible to change the library pattern" do
          rubygems.lib_pattern = "^another_lib/*/(.*)\.rb"
          rubygems.lib_pattern.should == "^another_lib/*/(.*)\.rb"
        end
        
      end
      
      describe '#test_pattern' do
        
        it "should return the pattern for Test::Unit" do
          rubygems.test_pattern.should == "^test/*/(.*)_test.rb"
        end
        
        it "should return the pattern for Rspec" do
          app = application_with_rspec
          InfinityTest.stub!(:application).and_return(app)
          rubygems.test_pattern.should == "^spec/*/(.*)_spec.rb"
        end
        
      end

      describe '#test_helper_pattern' do
        it "should return the pattern for Test::Unit" do
          rubygems.test_helper_pattern.should == "^test/*/test_helper.rb"
        end
        
        it "should return the pattern for Rspec" do
          app = application_with_rspec
          InfinityTest.stub!(:application).and_return(app)
          rubygems.test_helper_pattern.should == "^spec/*/spec_helper.rb"
        end
        
      end
      
    end
  end
end