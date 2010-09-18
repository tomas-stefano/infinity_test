require 'spec_helper'

module InfinityTest
  describe Application do
    let(:application) { Application.new }
    
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
          @application.test_framework.should be_instance_of(InfinityTest::Rspec)
        end
        
        it "should read the home configuration file and assign the test framework properly" do
          read_and_load_home_config :file => 'spec/factories/infinity_test_example'
          @application.test_framework.should be_instance_of(InfinityTest::TestUnit)
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
   
    describe '#image_to_show' do

      before do
        @application_with_rspec = application_with(:test_framework => :rspec)
        @application_with_test_unit = application_with(:test_framework => :test_unit)
      end

      it "should return sucess when pass all the tests" do
        test_should_not_fail!(@application_with_rspec)
        test_should_not_pending!(@application_with_rspec)
        @application_with_rspec.image_to_show.should match /sucess/
      end

      it "should return failure when not pass all the tests" do
        test_should_fail!(@application_with_rspec)
        @application_with_rspec.image_to_show.should match /failure/
      end

      it "should return pending when have pending tests" do
        test_should_not_fail!(@application_with_rspec)
        test_should_pending!(@application_with_rspec)
        @application_with_rspec.image_to_show.should match /pending/
      end

      def test_should_not_fail!(object)
        object.test_framework.should_receive(:failure?).and_return(false)      
      end

      def test_should_fail!(object)
        object.test_framework.should_receive(:failure?).and_return(true)
      end

      def test_should_pending!(object)
        object.test_framework.should_receive(:pending?).and_return(true)      
      end

      def test_should_not_pending!(object)
        object.test_framework.should_receive(:pending?).and_return(false)      
      end

    end
    
    describe '#notification_framework' do

      it "should return the Growl notification framework if has :growl" do
        application.config.notifications :growl
        application.notification_framework.should be_instance_of InfinityTest::Notifications::Growl
      end
      
      it "should return the Lib Notify if has :lib_notify" do
        application.config.notifications :lib_notify
        application.notification_framework.should be_instance_of InfinityTest::Notifications::LibNotify
      end

      it "should cache notification" do
        application.config.notifications :lib_notify
        notification = application.notification_framework
        application.notification_framework.should equal notification
      end

    end
    
    describe '#test_framework' do
      
      before do
        @application = Application.new
      end
      
      it "should return the instance of Rspec when test framework is Rspec" do
        @application.config.use :test_framework => :rspec
        @application.test_framework.should be_instance_of(InfinityTest::Rspec)
      end

      it "should return the instance of Rspec when test framework is Rspec" do
        @application.config.use :test_framework => :test_unit
        @application.test_framework.should be_instance_of(InfinityTest::TestUnit)
      end
      
      it "should pass all the rubies for the test_framework TestUnit" do
        @application.config.use :test_framework => :test_unit, :rubies => ['1.9.1', '1.9.2']
        TestUnit.should_receive(:new).with(:rubies => '1.9.1,1.9.2')
        @application.test_framework
      end

      it "should pass all the rubies for the test_framework Rspec" do
        @application.config.use :test_framework => :rspec, :rubies => ['1.9.1', '1.9.2']
        Rspec.should_receive(:new).with(:rubies => '1.9.1,1.9.2')
        @application.test_framework
      end
      
      it "should cache the test framework instance" do
        @application.config.use :test_framework => :rspec
        test_framework = @application.test_framework
        @application.test_framework.should equal test_framework
      end

    end
    
    describe '#verbose?' do

      it "should return to false when not set verbose" do
        @application.verbose?.should equal false
      end
         
      it "should return true when set verbose to true" do
        @application.config.verbose = true
        @application.verbose?.should be_true
      end
      
    end
    
  end
end