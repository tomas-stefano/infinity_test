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

    it "should return the before_env callback" do
      app = application_with(:test_framework => :rspec)
      proc = Proc.new { |application| application.test_framework.test_pattern = 'foo'; application.library_directory_pattern = 'bar' }
      app.config.before_env(&proc)
      app.before_environment_callback.should equal proc
      app.test_framework.test_pattern.should_not == 'foo'
      app.library_directory_pattern.should_not == 'bar'

      app.run_before_environment_callback!
      app.test_framework.test_pattern.should == 'foo'
      app.library_directory_pattern.should == 'bar'
    end

    it "should return the before callback" do
      app = application_with(:test_framework => :rspec)
      proc = Proc.new { 'To Infinity and beyond!' }
      app.config.before_run(&proc)
      app.before_callback.should equal proc
    end

    it "should return the block when set after callback" do
      app = application_with(:test_framework => :rspec)
      proc = Proc.new { 'To Infinity and beyond!' }
      app.config.after_run(&proc)
      app.after_callback.should equal proc
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
        @application.test_framework.should be_instance_of(InfinityTest::TestLibrary::Rspec)
      end

      it "should return the instance of Rspec when test framework is Rspec" do
        @application.config.use :test_framework => :test_unit
        @application.test_framework.should be_instance_of(InfinityTest::TestLibrary::TestUnit)
      end
      
      it "should pass all the rubies for the test_framework TestUnit" do
        @application.config.use :test_framework => :test_unit, :rubies => ['1.9.1', '1.9.2']
        InfinityTest::TestLibrary::TestUnit.should_receive(:new).with(:rubies => '1.9.1,1.9.2')
        @application.test_framework
      end

      it "should pass all the rubies for the test_framework Rspec" do
        @application.config.use :test_framework => :rspec, :rubies => ['1.9.1', '1.9.2']
        InfinityTest::TestLibrary::Rspec.should_receive(:new).with(:rubies => '1.9.1,1.9.2')
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

    describe '#notify!' do
      
      it "should do nothing when not have notification framework" do
        application.should_receive(:notification_framework).and_return(nil)
        application.notify!(:results => '0 examples', :ruby_version => '1.9.2').should be_nil
      end
      
      it "should notify when have notification framework" do
        application.config.notifications :growl
        application.notification_framework.should_receive(:notify)
        application.notify!(:results => '0 examples', :ruby_version => '1.8.7')
      end
      
    end

    describe '#run!' do
      let(:block) { Proc.new { 'w00t!' } }

      it 'should call the before all callback' do
        application_with_rspec.config.before(&block)
        application_with_rspec.before_callback.should_receive(:call)
        run_the_command(application_with_rspec)
      end
      
      it "should call the after all callback" do
        application_with_rspec.config.after(&block)
        application_with_rspec.after_callback.should_receive(:call)
        run_the_command(application_with_rspec)
      end
      
      it "should call the before each ruby callback" do
        application_with_rspec.config.before(:each_ruby, &block)
        application_with_rspec.before_each_ruby_callback.should_receive(:call)
        run_the_command(application_with_rspec)
      end
      
      it "should call the after each ruby callback" do
        application_with_rspec.config.after(:each_ruby, &block)
        application_with_rspec.after_each_ruby_callback.should_receive(:call)
        run_the_command(application_with_rspec)        
      end
      
    end


    describe "#app framework" do
      it "should equal app_framework's watch_file_path" do
        app=application_with(:app_framework => :rails)
        app.app_directory_pattern.should == ["^app/*/(.*)\.rb", "^app/views/(.*)"]
      end
    end
  end
end
