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
          :test_framework => :auto_discover
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
          mock(options).strategy.twice { :rbenv }
          subject.merge!
          base.strategy.should be :rbenv
        end

        it "should keep the rubies when options rubies is nil" do
          base.rubies = %w(jruby ree)
          mock(options).rubies { nil }
          subject.merge!
          base.rubies.should == %w(jruby ree)
        end

        it "should overwrite the rubies when options rubies is empty" do
          base.rubies = %w(jruby ree)
          mock(options).rubies.twice { [] }
          subject.merge!
          base.rubies.should be_blank
        end

        it "should merge the rubies" do
          mock(options).rubies.twice { %w(ree jruby) }
          subject.merge!
          base.rubies.should eql %w(ree jruby)
        end

        it "should keep the test framework when options test framework is blank" do
          subject.merge!
          base.test_framework.should be :auto_discover
        end

        it "should merge the test library" do
          mock(options).test_framework.twice { :rspec }
          subject.merge!
          base.test_framework.should be :rspec
        end

        it "should keep the framework when options framework is blank" do
          subject.merge!
          base.framework.should be :auto_discover
        end

        it "should merge the framework" do
          mock(options).framework.twice { :rails }
          subject.merge!
          base.framework.should be :rails
        end

        it "should keep the specific option when options specific is blank" do
          subject.merge!
          base.specific_options.should eql ''
        end

        it "should merge the specific options" do
          mock(options).specific_options.twice { '-J -Ilib -Itest' }
          subject.merge!
          base.specific_options.should eql '-J -Ilib -Itest'
        end

        it "should keep the verbose mode when verbose mode is blank" do
          subject.merge!
          base.verbose.should be_true
        end

        it "should merge the verbose mode" do
          mock(options).verbose.twice { false }
          subject.merge!
          base.verbose.should be_false
        end

        it "should keep the bundler default when bundler is blank" do
          subject.merge!
          base.bundler.should be_true
        end

        it "should merge the verbose mode" do
          mock(options).bundler.twice { false }
          subject.merge!
          base.bundler.should be_false
        end
      end
    end
  end
end