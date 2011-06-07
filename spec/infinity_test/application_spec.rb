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

      it "should return the rubies in the config" do
        application_with(:rubies => ['1.8.7']).rubies.should == '1.8.7'
      end

      it "should return the rubies in the config" do
        application_with(:rubies => ['1.9.2']).rubies.should == '1.9.2'
      end

      it "should return the specific options in the config" do
        application_with(:specific_options => {'v-1' => '-o'}).specific_options.should == {'v-1' => '-o'}
      end

      it "should return the watchr script instance" do
        application_with_rspec.watchr.should be_instance_of(Watchr::Script)
      end

      it "should return the same object in the infinity test watchr" do
        application_with_rspec.watchr.should equal InfinityTest.watchr
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

    describe '#add_heuristics!' do

      it "rules should be empty before call add_heuristics! method" do
        InfinityTest.watchr.rules.should be_empty
      end

      it "should add rule sto the scope of Watchr::Script" do
        application.add_heuristics!
        InfinityTest.watchr.rules.should_not be_empty
      end

    end

    describe '#heuristics_users_high_priority!' do

      before do
        @application = application_with(:test_framework => :rspec, :app_framework => :rubygems)
        @application.heuristics.add('my_rule.rb')
        @application.heuristics.add('other_rule.rb')
      end

      it "should reverse the rules of watchr" do
        @application.heuristics_users_high_priority!
        @application.watchr.patterns[0].should == 'other_rule.rb'
        @application.watchr.patterns[1].should == 'my_rule.rb'
      end

    end

    describe '#setup!' do

      it 'should prioritize rubies in the Hash options' do
        application.config.use(:rubies => %w(jruby))
        application.setup!(:rubies => %w(ree))
        application.rubies.should == 'ree'
      end

      it 'should prioritize specific options in the Hash options' do
        application.config.use(:specific_options => '-j')
        application.setup!(:specific_options => '-x')
        application.specific_options.should == '-x'
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
        application.notification_framework.should equal :growl
      end

      it "should return the Lib Notify if has :lib_notify" do
        application.config.notifications :lib_notify
        application.notification_framework.should equal :lib_notify
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
        InfinityTest::TestLibrary::TestUnit.should_receive(:new).with(:rubies => '1.9.1,1.9.2', :specific_options=>nil)
        @application.test_framework
      end

      it "should pass all the rubies for the test_framework Rspec" do
        @application.config.use :test_framework => :rspec, :rubies => ['1.9.1', '1.9.2']
        InfinityTest::TestLibrary::Rspec.should_receive(:new).with(:rubies => '1.9.1,1.9.2', :specific_options=>nil)
        @application.test_framework
      end

      it "should pass specific options for the test_framework Rspec" do
        @application.config.use :test_framework => :rspec, :rubies => ['1.9.1', 'jruby'], :specific_options => {'jruby' => '-J-cp :.'}
        InfinityTest::TestLibrary::Rspec.should_receive(:new).with(:rubies => '1.9.1,jruby', :specific_options => {'jruby' => '-J-cp :.'})
        @application.test_framework
      end

      it "should pass the bacon framework too" do
        @application.config.use :test_framework => :bacon
        @application.test_framework.should be_instance_of(InfinityTest::TestLibrary::Bacon)
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
        @application.config.use :verbose => true
        @application.verbose?.should be_true
      end

    end

    describe '#notify!' do

      before do
        @growl = Growl.new
      end

      it "should do nothing when not have notification framework" do
        application.should_receive(:notification_framework).and_return(nil)
        application.notify!(:results => '0 examples', :ruby_version => '1.9.2').should be_nil
      end

      it "should notify when have notification framework" do
        application.config.notifications :growl
        application.should_receive(:growl).and_return(@growl)
        @growl.should_receive(:notify!)
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

    describe '#global_commands' do

      it "should call construct commands and assign to the global_commands" do
        @application.should_receive(:construct_command).and_return(ConstructCommand.new)
        @application.global_commands
      end

      it "should cache the global_commands instance variable" do
        expected = ['rvm 1.9.2']
        construct_command = ConstructCommand.new
        construct_command.stub_chain(:create, :command => expected)
        @application.should_receive(:construct_command).once.and_return(construct_command)
        2. times { @application.global_commands.should equal expected }
      end

    end

    describe '#run_global_commands!' do

      it "should run with the global_commands instance variable command" do
        @application.stub!(:global_commands).and_return('rvm 1.9.2 ruby -S rspec')
        @application.should_receive(:run!).with(@application.global_commands).and_return(true)
        @application.run_global_commands!
      end

    end

    describe '#construct_command' do
      it { @application.construct_command.should be_instance_of(ConstructCommand) }
    end

    describe '#construct_commands_for_changed_files' do
      
      it 'should pass responsability to test framework' do
        construct_command = ConstructCommand.new
        options = { :files_to_run => 'file_search_test.rb file_test.rb' }
        ConstructCommand.should_receive(:new).with(options).and_return(construct_command)
        application.construct_commands_for_changed_files('file_search_test.rb file_test.rb')
      end
    end

    describe "#app framework" do

      it "should return the instance of Rails when app framework is Rails" do
        application_with_rails.app_framework.should be_instance_of(InfinityTest::ApplicationLibrary::Rails)
      end

      it "should return the instance of Rubygems when app framework is Rubygems" do
        application_with_rubygems.app_framework.should be_instance_of(InfinityTest::ApplicationLibrary::RubyGems)
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

    describe '#binary_search' do
      before do
        @environment = RVM.current
        @app_rspec = application_with_rspec
        @app_test_unit = application_with_test_unit
      end

      it 'should return the rspec binary when the application is using rspec' do
        @app_rspec.should_receive(:binary_search).with(@environment).and_return("rspec")
        @app_rspec.binary_search(@environment).should == "rspec"
      end
    end

  end
end
