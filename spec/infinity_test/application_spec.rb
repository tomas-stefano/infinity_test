require 'spec_helper'

module InfinityTest
  describe Application do
    
    before(:each) do
      @application = Application.new
    end
    
    context "when styles" do
      
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
    
    describe "#run!" do
            
      it "should run!" do
        @application.should_receive(:say).and_return(nil)
        lambda { @application.run!(['--rspec']) }.should_not raise_exception
      end
      
      it "should call cucumber style" do
        @application.should_receive(:load_cucumber_style)
        @application.run!(['--cucumber'])
      end
      
      it "should call rspec style" do
        @application.should_receive(:load_rspec_style)
        @application.run!(['--rspec'])
      end
      
    end
    
  end
end