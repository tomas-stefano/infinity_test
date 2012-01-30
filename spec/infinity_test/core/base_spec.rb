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

    describe ".strategy_class" do
      before do
        @old_strategy = Base.strategy
      end

      after do
        Base.strategy = @old_strategy
      end

      it "should return the right class strategy" do
        Base.strategy = :auto_discover
        Base.strategy_class.should be InfinityTest::Strategy::AutoDiscover
      end

      it "should return rbenv when" do
        Base.strategy = :rbenv
        Base.strategy_class.should be InfinityTest::Strategy::Rbenv
      end
    end

    describe ".ruby_strategy" do
      before do
        @old_strategy = Base.strategy
      end

      after do
        Base.strategy = @old_strategy
      end

      it "should create an instance of strategy class pass base as option" do
        Base.strategy = :auto_discover
        mock(Strategy::AutoDiscover).new(Base) { :foo }
        Base.ruby_strategy.should be :foo
      end

      it "should create an instance for rbenv strategy" do
        Base.strategy = :rbenv
        mock(Strategy::Rbenv).new(Base) { :bar }
        Base.ruby_strategy.should be :bar
      end
    end

    describe ".observer" do
      it "should have watchr as default observer" do
        Base.observer.should equal :watchr
      end
    end

    describe ".run_strategy!" do
      it "should call ruby_strategy and run it!" do
        mock(Base).ruby_strategy { Strategy::Base }
        mock(Strategy::Base).run! { true }
        Base.run_strategy!
      end
    end

    describe ".before" do
      let(:proc) { Proc.new { 'To Infinity and beyond!' } }

      it "should create before callback instance and push to the callback accessor" do
        mock(BeforeCallback).new(:all, &proc).once { :foo }
        before_callback = Base.before(:all, &proc)
        before_callback.should be :foo
        Base.callbacks.should be_include before_callback
      end
    end

    describe ".after" do
      let(:proc) { Proc.new {}}

      it "should create before callback instance and push to the callback accessor" do
        mock(AfterCallback).new(:each, &proc).once { :foo }
        after_callback = Base.after(:each, &proc)
        after_callback.should be :foo
        Base.callbacks.should be_include after_callback
      end
    end

    describe ".notifications" do
      it "should set the notification class accessor" do
        silence_warnings do
          Base.notifications(:growl)
          Base.notification.should be :growl
        end
      end

      it "should set the images" do
        silence_warnings do
          Base.notifications(:growl) do
            show_images :success_image => 'foo', :failure_image => 'bar', :pending_image => 'baz'
          end
        end
        Base.success_image.should eql 'foo'
        Base.failure_image.should eql 'bar'
        Base.pending_image.should eql 'baz'
      end

      it "should set the mode" do
        silence_warnings do
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
        Base.use :rubies => %w(foo bar)
        Base.rubies.should eql %w(foo bar)
      end

      it "should set the specific options" do
        Base.use :specific_options => '-J -Ilib -Itest'
        Base.specific_options.should eql '-J -Ilib -Itest'
      end

      it "should set the test framework" do
        Base.use :test_framework => :rspec
        Base.test_framework.should be :rspec
      end

      it "should set the app framework" do
        Base.use :app_framework => :rails
        Base.framework.should be :rails
      end

      it "should set the verbose mode" do
        Base.use :verbose => false
        Base.verbose.should equal false # I choose to don't use should be_false
      end

      it "should set the gemset" do
        Base.use :gemset => 'infinity_test'
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
      let(:options) { Options.new([]) }

      it "should keep the strategy when options strategy is blank" do
        Base.merge!(options).strategy.should be :auto_discover
      end

      it "should merge the strategies" do
        mock(options).strategy.twice { :rbenv }
        Base.merge!(options).strategy.should be :rbenv
      end

      it "should keep the rubies when options rubies is blank" do
        Base.merge!(options).rubies.should be_blank
      end

      it "should merge the rubies" do
        mock(options).rubies.twice { %w(ree jruby) }
        Base.merge!(options).rubies.should eql %w(ree jruby)
      end

      it "should keep the test framework when options test framework is blank" do
        Base.merge!(options).test_framework.should be :auto_discover
      end

      it "should merge the test library" do
        mock(options).test_framework.twice { :rspec }
        Base.merge!(options).test_framework.should be :rspec
      end

      it "should keep the framework when options framework is blank" do
        Base.merge!(options).framework.should be :auto_discover
      end

      it "should merge the framework" do
        mock(options).framework.twice { :rails }
        Base.merge!(options).framework.should be :rails
      end

      it "should keep the specific option when options specific is blank" do
        Base.merge!(options).specific_options.should eql ''
      end

      it "should merge the specific options" do
        mock(options).specific_options.twice { '-J -Ilib -Itest' }
        Base.merge!(options).specific_options.should eql '-J -Ilib -Itest'
      end

      it "should keep the verbose mode when verbose mode is blank" do
        Base.merge!(options).verbose.should be_true
      end

      it "should merge the verbose mode" do
        mock(options).verbose.twice { false }
        Base.merge!(options).verbose.should be_false
      end

      it "should keep the bundler default when bundler is blank" do
        Base.merge!(options).bundler.should be_true
      end

      it "should merge the verbose mode" do
        mock(options).bundler.twice { false }
        Base.merge!(options).bundler.should be_false
      end
    end

    describe ".clear" do
      it "should call clear_terminal method" do
        silence_warnings do
          mock(Base).clear_terminal { true }
          Base.clear(:terminal)
        end
      end
    end

    describe ".clear_terminal" do
      it "should call system clear" do
        silence_warnings do
          mock(Base).system('clear') { true }
          Base.clear_terminal
        end
      end
    end
  end
end