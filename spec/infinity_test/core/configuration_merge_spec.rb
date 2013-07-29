require 'spec_helper'

module InfinityTest
  module Core
    describe ConfigurationMerge do
      let(:base) do
        OpenStruct.new(
          :bundler => true,
          :verbose => true,
          :strategy => :auto_discover,
          :observer => :watchr,
          :rubies => [],
          :specific_options => '',
          :framework => :auto_discover,
          :test_framework => :auto_discover,
          :infinity_and_beyond => true
        )
      end

      let(:options) { Options.new([]) }
      subject { ConfigurationMerge.new(base, options) }

      describe "#merge!" do
        it "should keep the strategy when options strategy is blank" do
          subject.merge!
          base.strategy.should be :auto_discover
        end

        it "should merge the strategies" do
          options.should_receive(:strategy).twice.and_return(:rbenv)
          subject.merge!
          base.strategy.should be :rbenv
        end

        it "should keep the rubies when options rubies is nil" do
          base.rubies = %w(jruby ree)
          options.should_receive(:rubies).and_return(nil)
          subject.merge!
          base.rubies.should == %w(jruby ree)
        end

        it "should overwrite the rubies when options rubies is empty" do
          base.rubies = %w(jruby ree)
          options.should_receive(:rubies).twice.and_return([])
          subject.merge!
          base.rubies.should be_blank
        end

        it "should merge the rubies" do
          options.should_receive(:rubies).twice.and_return(%w(ree jruby))
          subject.merge!
          base.rubies.should eql %w(ree jruby)
        end

        it "should keep the test framework when options test framework is blank" do
          subject.merge!
          base.test_framework.should be :auto_discover
        end

        it "should merge the test library" do
          options.should_receive(:test_framework).twice.and_return(:rspec)
          subject.merge!
          base.test_framework.should be :rspec
        end

        it "should keep the framework when options framework is blank" do
          subject.merge!
          base.framework.should be :auto_discover
        end

        it "should merge the framework" do
          options.should_receive(:framework).twice.and_return(:rails)
          subject.merge!
          base.framework.should be :rails
        end

        it "should keep the specific option when options specific is blank" do
          subject.merge!
          base.specific_options.should eql ''
        end

        it "should merge the specific options" do
          options.should_receive(:specific_options).twice.and_return('-J -Ilib -Itest')
          subject.merge!
          base.specific_options.should eql '-J -Ilib -Itest'
        end

        it "should merge with the infinity test and beyond" do
          options.should_receive(:infinity_and_beyond).twice.and_return(false)
          subject.merge!
          base.infinity_and_beyond.should equal false
        end

        it "should keep the base default if option infinity test and beyond is nil" do
          options.should_receive(:infinity_and_beyond).and_return(nil)
          subject.merge!
          base.infinity_and_beyond.should be_true
        end

        it "should keep the verbose mode when verbose mode is blank" do
          subject.merge!
          base.verbose.should be_true
        end

        it "should merge the verbose mode" do
          options.should_receive(:verbose).twice.and_return(false)
          subject.merge!
          base.verbose.should be_false
        end

        it "should keep the bundler default when bundler is blank" do
          subject.merge!
          base.bundler.should be_true
        end

        it "should merge the verbose mode" do
          options.should_receive(:bundler).twice.and_return(false)
          subject.merge!
          base.bundler.should be_false
        end
      end
    end
  end
end