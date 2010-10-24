require 'spec_helper'

module InfinityTest
  describe Application do
    let(:application) { Application.new }
    let(:config) { Configuration.new }

    before(:each) do
      @application = Application.new
      @current_dir = Dir.pwd
    end

    describe '#initialize' do
      
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
    end

    describe '#heuristics' do

      it "should be instance of Heuristics class" do
        @application.config.heuristics {}
        @application.heuristics.should be_instance_of(InfinityTest::Heuristics)
      end
      
      it "should be the same heuristics setting in the configuration file" do
        heuristics = @application.config.heuristics {}
        heuristics.should equal @application.heuristics
      end
      
    end
    
    describe '#have_gemfile?' do
      
      it "should return true when Gemfile exists" do
        application.should_receive(:gemfile).and_return(factory_company_gemfile)
        application.have_gemfile?.should be_true
      end
      
      it "should return false when Gemfile not exists" do
        application.should_receive(:gemfile).and_return(factory_buzz_gemfile)
        application.have_gemfile?.should be_false
      end
      
    end

    describe '#skip_bundler?' do
      
      it "should return true if skip_bundler! is set" do
        application.config.skip_bundler!
        application.skip_bundler?.should be_true
      end
      
      it "should return false if skip_bundler! is not set" do
        InfinityTest.should_receive(:configuration).and_return(config)
        Application.new.skip_bundler?.should be_false
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
      before(:each) do
        @app_rails=application_with(:app_framework => :rails)
        @rails=@app_rails.app_framework
      end
      it "should return the instance of Rails when app framework is Rails" do
        @app_rails.app_framework.should be_instance_of(InfinityTest::Rails)
      end
      
      it "should return the rails app_watch_path" do
        @app_rails.app_directory_pattern.should == @rails.app_watch_path
      end
      
      
    end

    describe '#using_test_unit?' do
      
      it "should return true when using Test::Unit" do
        app = application_with_test_unit
        app.using_test_unit?.should be_true
      end
      
      it "should return false when using Rspec" do
        app = application_with_rspec
        app.using_test_unit?.should be_false
      end
      
    end
  
  end
end
