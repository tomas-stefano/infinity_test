require 'spec_helper'

module InfinityTest
  describe Application do
    
    before(:each) do
      @application = Application.new
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
    
    describe 'styles' do
      
      before(:each) do
        @test_unit = TestUnit.new
        @rspec = Rspec.new
        @cucumber = Cucumber.new
      end
      
      it "should call TestUnit new" do
        TestUnit.should_receive(:new).and_return(@test_unit)
        @application.should_receive(:say).with('Style: Test::Unit')
        @test_unit.should_receive(:build_command_string)
        @application.load_test_unit_style
      end
      
      it "should call Rspec new" do
        Rspec.should_receive(:new).and_return(@rspec)
        @application.should_receive(:say).with('Style: Rspec')
        @rspec.should_receive(:build_command_string)
        @application.load_rspec_style
      end
      
      it "should call Cucumber new" do
        Cucumber.should_receive(:new).and_return(@cucumber)
        @application.should_receive(:say).with('Style: Cucumber')
        @cucumber.should_receive(:build_command_string)
        @application.load_cucumber_style
      end
      
    end
    
    describe "#resolve_ruby_versions" do
      
      it "should set the ruby_versions instance properly with one version" do
        @application.resolve_ruby_versions("1.8.7")
        @application.ruby_versions.should eql '1.8.7'
      end
      
      it "should set the ruby_versions instance properly with dashes" do
        @application.resolve_ruby_versions("1.8.6,1.8.7,1.9.1-p378")
        @application.instance_variable_get(:@ruby_versions).should eql '1.8.6,1.8.7,1.9.1-p378'
      end
      
      it "should set the ruby_versions properly" do
        @application.resolve_ruby_versions("1.8.6,1.8.7")
        @application.ruby_versions.should eql '1.8.6,1.8.7'
      end
      
    end
        
  end
end