require 'spec_helper'

module InfinityTest
  module Core
    describe CommandBuilder do
      describe "#add" do
        it "should add the argument in the command" do
          expect(subject.ruby.option(:S).add(:rspec).add(:spec)).to eq 'ruby -S rspec spec'
        end
      end

      describe "#option" do
        it "should put options with one dash and be possible to add more keywords" do
          expect(subject.bundle.exec.ruby.option(:S).rspec).to eq 'bundle exec ruby -S rspec'
        end
      end

      describe "#opt" do
        it "should put double dash options and be possible to add keywords" do
          expect(subject.ruby.opt(:copyright)).to eq 'ruby --copyright'
        end
      end

      describe '#method_missing' do
        it "should put space after every keyword" do
          expect(subject.bundle.exec.ruby.some_file).to eq 'bundle exec ruby some_file'
        end
      end

      describe "#respond_to?" do
        it "should respond to enything because missing methods will build the command" do
          expect(subject.respond_to?(:foo)).to be_true
          expect(subject.respond_to?(:bar)).to be_true
        end
      end
    end
  end
end