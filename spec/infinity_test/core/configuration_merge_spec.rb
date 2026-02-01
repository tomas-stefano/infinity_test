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
        it "keeps the strategy when options strategy is blank" do
          subject.merge!
          expect(base.strategy).to be :auto_discover
        end

        it "merges the strategies" do
          expect(options).to receive(:strategy).twice.and_return(:rbenv)
          subject.merge!
          expect(base.strategy).to be :rbenv
        end

        it "keeps the rubies when options rubies is nil" do
          base.rubies = %w(jruby ree)
          expect(options).to receive(:rubies).and_return(nil)
          subject.merge!
          expect(base.rubies).to eq %w(jruby ree)
        end

        it "overwrites the rubies when options rubies is empty" do
          base.rubies = %w(jruby ree)
          expect(options).to receive(:rubies).twice.and_return([])
          subject.merge!
          expect(base.rubies).to be_blank
        end

        it "merges the rubies" do
          expect(options).to receive(:rubies).twice.and_return(%w(ree jruby))
          subject.merge!
          expect(base.rubies).to eql %w(ree jruby)
        end

        it "keeps the test framework when options test framework is blank" do
          subject.merge!
          expect(base.test_framework).to be :auto_discover
        end

        it "merges the test library" do
          expect(options).to receive(:test_framework).twice.and_return(:rspec)
          subject.merge!
          expect(base.test_framework).to be :rspec
        end

        it "keeps the framework when options framework is blank" do
          subject.merge!
          expect(base.framework).to be :auto_discover
        end

        it "merges the framework" do
          expect(options).to receive(:framework).twice.and_return(:rails)
          subject.merge!
          expect(base.framework).to be :rails
        end

        it "keeps the specific option when options specific is blank" do
          subject.merge!
          expect(base.specific_options).to eql ''
        end

        it "merges the specific options" do
          expect(options).to receive(:specific_options).twice.and_return('-J -Ilib -Itest')
          subject.merge!
          expect(base.specific_options).to eql '-J -Ilib -Itest'
        end

        it "merges with the infinity test and beyond" do
          expect(options).to receive(:infinity_and_beyond).twice.and_return(false)
          subject.merge!
          expect(base.infinity_and_beyond).to be false
        end

        it "keeps the base default if option infinity test and beyond is nil" do
          expect(options).to receive(:infinity_and_beyond).and_return(nil)
          subject.merge!
          expect(base.infinity_and_beyond).to be true
        end

        it "keeps the verbose mode when verbose mode is blank" do
          subject.merge!
          expect(base.verbose).to be true
        end

        it "merges the verbose mode" do
          expect(options).to receive(:verbose).twice.and_return(false)
          subject.merge!
          expect(base.verbose).to be false
        end

        it "keeps the bundler default when bundler is blank" do
          subject.merge!
          expect(base.bundler).to be true
        end

        it "merges the bundler mode" do
          expect(options).to receive(:bundler).twice.and_return(false)
          subject.merge!
          expect(base.bundler).to be false
        end
      end
    end
  end
end
