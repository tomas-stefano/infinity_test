require "spec_helper"
require 'active_support/core_ext/kernel'

module InfinityTest
  describe Base do
    describe ".setup" do
      it "should yield self" do
        Base.setup do |config|
          config.should == InfinityTest::Base
        end
      end
    end

    describe ".using_bundler?" do
      it "should return the same bundler accessor" do
        Base.using_bundler?.should equal Base.bundler
      end
    end

    describe "#verbose?" do
      it "should return the same verbose accessor" do
        Base.verbose?.should equal Base.verbose
      end
    end

    describe ".observer" do
      it "should have watchr as default observer" do
        Base.observer.should equal :watchr
      end
    end

    describe ".ignore_test_files" do
      it "should not have test files to ignore as default" do
        Base.ignore_test_files.should eql []
      end
    end

    describe "#ignore_test_folders" do
      it "should not ignore test folders as default" do
        Base.ignore_test_folders.should eql []
      end
    end

    describe "#strategy_instance" do
      it "should return auto discover as default" do
        Base.strategy_instance.should be_instance_of(InfinityTest::Strategy::AutoDiscover)
      end
    end

    describe "#observer_instance" do
      it "should return watchr as default" do
        Base.observer_instance.should be_instance_of(InfinityTest::Observer::Watchr)
      end
    end

    describe "#test_framework_instance" do
      it "should return auto discover as default" do
        Base.test_framework_instance.should be_instance_of(InfinityTest::TestFramework::AutoDiscover)
      end
    end

    describe "#framework_instance" do
      it "should return auto discover as default" do
        Base.framework_instance.should be_instance_of(InfinityTest::Framework::AutoDiscover)
      end

      it 'return the class by the framework name' do
        Base.should_receive(:framework).and_return(:rubygems)
        Base.framework_instance.should be_a InfinityTest::Framework::Rubygems
      end
    end

    describe ".before" do
      let(:proc) { Proc.new { 'To Infinity and beyond!' } }

      it "should create before callback instance and push to the callback accessor" do
        BeforeCallback.should_receive(:new).with(:all, &proc).once.and_return(:foo)
        before_callback = Base.before(:all, &proc)
        before_callback.should be :foo
        Base.callbacks.should be_include before_callback
      end
    end

    describe ".after" do
      let(:proc) { Proc.new {}}

      it "should create before callback instance and push to the callback accessor" do
        AfterCallback.should_receive(:new).with(:each, &proc).once.and_return(:foo)
        after_callback = Base.after(:each, &proc)
        after_callback.should be :foo
        Base.callbacks.should be_include after_callback
      end
    end

    describe ".notifications" do
      it "should set the notification class accessor" do
        silence_stream(STDOUT) do
          Base.notifications(:growl)
          Base.notification.should be :growl
        end
      end

      it "should set the images" do
        silence_stream(STDOUT) do
          Base.notifications(:growl) do
            show_images :success_image => 'foo', :failure_image => 'bar', :pending_image => 'baz'
          end
        end
        Base.success_image.should eql 'foo'
        Base.failure_image.should eql 'bar'
        Base.pending_image.should eql 'baz'
      end

      it "should set the mode" do
        silence_stream(STDOUT) do
          Base.notifications(:growl) do
            show_images :mode => :mortal_kombat
          end
        end
        Base.mode.should be :mortal_kombat
      end
    end

    describe ".use" do
      before do
        @old_rubies = Base.rubies
        @old_specific_options = Base.specific_options
        @test_framework = Base.test_framework
        @framework = Base.framework
        @verbose = Base.verbose
        @gemset  = Base.gemset
      end

      after do
        Base.rubies = @old_rubies
        Base.specific_options = @old_specific_options
        Base.test_framework = @test_framework
        Base.framework = @framework
        Base.verbose = @verbose
        Base.gemset = @gemset
      end

      it "should set the rubies" do
        silence_stream(STDOUT) do
          Base.use :rubies => %w(foo bar)
        end
        Base.rubies.should eql %w(foo bar)
      end

      it "should set the specific options" do
        silence_stream(STDOUT) do
          Base.use :specific_options => '-J -Ilib -Itest'
        end
        Base.specific_options.should eql '-J -Ilib -Itest'
      end

      it "should set the test framework" do
        silence_stream(STDOUT) do
          Base.use :test_framework => :rspec
        end
        Base.test_framework.should be :rspec
      end

      it "should set the app framework" do
        silence_stream(STDOUT) do
          Base.use :app_framework => :rails
        end
        Base.framework.should be :rails
      end

      it "should set the verbose mode" do
        silence_stream(STDOUT) do
          Base.use :verbose => false
        end
        Base.verbose.should equal false # I choose to don't use should be_false
      end

      it "should set the gemset" do
        silence_stream(STDOUT) do
          Base.use :gemset => 'infinity_test'
        end
        Base.gemset.should eql 'infinity_test'
      end
    end

    describe ".heuristics" do
      it "should need to see." do
        pending 'Need to see what to do with the patterns to watch'
      end
    end

    describe ".replace_patterns" do
      it "should need to see" do
        pending 'Need to see how improve this method.'
      end
    end

    describe ".merge!" do
      let(:options) { Object.new }
      let(:configuration_merge) { Object.new }

      it "should call merge on the configuration merge object" do
        ConfigurationMerge.should_receive(:new).with(Core::Base, options).and_return(configuration_merge)
        configuration_merge.should_receive(:merge!)
        Core::Base.merge!(options)
      end
    end

    describe ".clear" do
      it "should call clear_terminal method" do
        silence_stream(STDOUT) do
          Base.should_receive(:clear_terminal).and_return(true)
          Base.clear(:terminal)
        end
      end
    end

    describe ".clear_terminal" do
      it "should call system clear" do
        silence_stream(STDOUT) do
          Base.should_receive(:system).with('clear').and_return(true)
          Base.clear_terminal
        end
      end
    end
  end
end