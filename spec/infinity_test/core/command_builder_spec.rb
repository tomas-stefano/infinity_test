require 'spec_helper'

module InfinityTest
  module Core
    describe CommandBuilder do
      context 'constructing the command' do
        it "should put space after every keyword" do
          subject.bundle.exec.ruby.should == 'bundle exec ruby'
        end

        it "should put options with one dash and be possible to add more keywords" do
          subject.bundle.exec.ruby.option(:S).rspec.should == 'bundle exec ruby -S rspec'
        end

        it "should put double dash options and be possible to add keywords" do
          subject.ruby.opt(:copyright).should == 'ruby --copyright'
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