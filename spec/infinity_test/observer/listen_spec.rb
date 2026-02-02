require 'spec_helper'

module InfinityTest
  module Observer
    describe Listen do
      let(:continuous_server) { double }
      subject { Listen.new(continuous_server) }

      it_should_behave_like 'an infinity test observer'

      describe "#patterns" do
        it "starts as an empty hash" do
          expect(subject.patterns).to eq({})
        end
      end

      describe "#directories" do
        it "starts as an empty array" do
          expect(subject.directories).to eq([])
        end
      end

      describe "#watch" do
        it "adds a pattern with its block to patterns" do
          block = proc { |file| file }
          subject.watch('lib/(.*)\.rb', &block)
          expect(subject.patterns.keys.first).to be_a(Regexp)
          expect(subject.patterns.values.first).to eq(block)
        end
      end

      describe "#watch_dir" do
        it "adds a pattern to patterns" do
          subject.watch_dir(:spec)
          expect(subject.patterns.keys.first.source).to eq('^spec/*/(.*).rb')
        end

        it "adds the directory to directories" do
          subject.watch_dir(:spec)
          expect(subject.directories).to include('spec')
        end

        it "accepts a custom extension" do
          subject.watch_dir(:spec, :py)
          expect(subject.patterns.keys.first.source).to eq('^spec/*/(.*).py')
        end
      end
    end
  end
end
