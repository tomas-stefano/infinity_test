require 'spec_helper'

module InfinityTest
  describe Application do
    
    before(:each) do
      @application = Application.new
    end
    
    it "should return test_unit pattern for test unit" do
      @application.library_directory_pattern.should eql "^lib/*/(.*)\.rb"
    end
    
    it "should return the rubies in the config" do
      application_with(:rubies => ['1.8.7']).rubies.should == '1.8.7'
    end
    
    it "should return the rubies in the config" do
      application_with(:rubies => ['1.9.2']).rubies.should == '1.9.2'
    end
    
    it "should return the before callback" do
      app = application_with(:cucumber => true)
      proc = Proc.new { 'To Infinity and beyond!' }
      app.config.before_run(&proc)
      app.before_callback.should equal proc
    end

    it "should return the test framework" do
      app = application_with(:test_framework => :rspec)
      app.test_framework.should equal :rspec
    end
    
    it "should return true when use cucumber" do
      app = application_with(:cucumber => true)
      app.cucumber?.should be_true    
    end
    
    it "should return true when use cucumber" do
      app = application_with(:cucumber => false)
      app.cucumber?.should be_false    
    end

    it "should return the block when set after callback" do
      app = application_with(:cucumber => true)
      proc = Proc.new { 'To Infinity and beyond!' }
      app.config.after_run(&proc)
      app.after_callback.should equal proc
    end
    
    it "should return the notification framework" do
      app = application_with(:cucumber => true)
      app.config.notifications :growl
      app.notification_framework.should equal :growl
    end
 
    describe '#load_configuration_file' do
      
      context 'when global configuration' do
        
        before do
          @application.should_receive(:load_project_configuration).and_return(nil)
        end
        
        it "should read the configuration file and assign properly the rvm versions" do
          read_and_load_home_config :file => 'spec/factories/infinity_test_example'
          @application.rubies.should be == '1.8.7-p249,1.9.1'
        end
        
        it "should read the home configuration file and assign the rvm versions" do
          read_and_load_home_config :file => 'spec/factories/infinity_test'
          @application.rubies.should be == '1.8.7-p249,1.9.1,1.9.2'
        end
        
        it "should read the home configuration file and assign the test framework" do
          read_and_load_home_config :file => 'spec/factories/infinity_test'
          @application.test_framework.should equal :rspec
        end
        
        it "should read the home configuration file and assign the test framework properly" do
          read_and_load_home_config :file => 'spec/factories/infinity_test_example'
          @application.test_framework.should equal :test_unit
        end
        
        it "should read the home configuration file and assign the cucumber library" do
          read_and_load_home_config :file => 'spec/factories/infinity_test'
          @application.cucumber?.should be_true
        end
        
        it "should read the home configuration file and assign the cucumber library as false when not have cucumber option" do
          read_and_load_home_config :file => 'spec/factories/infinity_test_example'
          @application.cucumber?.should equal false
        end
      end

    end
    
  end
end