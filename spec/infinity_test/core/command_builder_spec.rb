require 'spec_helper'

module InfinityTest
  module Core
    describe CommandBuilder do
      describe "#add" do
        it "should add the argument in the command" do
          subject.ruby.option(:S).add(:rspec).add(:spec).should == 'ruby -S rspec spec'
        end
      end

      describe "#option" do
        it "should put options with one dash and be possible to add more keywords" do
          subject.bundle.exec.ruby.option(:S).rspec.should == 'bundle exec ruby -S rspec'
        end
      end

      describe "#opt" do
        it "should put double dash options and be possible to add keywords" do
          subject.ruby.opt(:copyright).should == 'ruby --copyright'
        end
      end

      describe '#method_missing' do
        it "should put space after every keyword" do
          subject.bundle.exec.ruby.some_file.should == 'bundle exec ruby some_file'
        end
      end

      describe "#respond_to?" do
        it "should respond to enything because missing methods will build the command" do
          subject.respond_to?(:foo).should be_true
          subject.respond_to?(:bar).should be_true
        end
      end
    end
  end
end