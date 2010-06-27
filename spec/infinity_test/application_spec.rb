require 'spec_helper'

module InfinityTest
  describe Application do
    
    before(:each) do
      @application = Application.new
    end
    
    context "default instances" do
      
      it "should have a empty ruby versions" do
        @application.ruby_versions.should be_empty
      end
      
      it "should be an Array" do
        @application.ruby_versions.should eql []
      end
      
      it "should have a empty styles" do
        @application.styles.should be_empty
      end
      
      it "should be an Array" do
        @application.styles.should eql []
      end
      
    end
    
    describe '#application' do
      
      it "should be a instace of Application" do
        InfinityTest.application.should be_instance_of(Application)
      end
      
      it "should cache instance variable" do
        application = InfinityTest.application
        InfinityTest.application.should equal application
      end
      
    end
    
    describe "#resolve_ruby_versions" do
      
      it "should set the ruby_versions instance properly with one version" do
        @application.resolve_ruby_versions("1.8.7")
        @application.ruby_versions.should eql ['1.8.7']
      end
      
      it "should set the ruby_versions instance properly with many versions" do
        @application.resolve_ruby_versions("1.8.6,1.8.7,1.9.1-p378")
        @application.ruby_versions.should eql ['1.8.6', '1.8.7', '1.9.1-p378']
      end
      
      it "should select the ruby_versions properly" do
        @application.resolve_ruby_versions("1.8.6,1.8.7")
        @application.ruby_versions.should eql ['1.8.6', '1.8.7']
      end
      
    end
        
  end
end