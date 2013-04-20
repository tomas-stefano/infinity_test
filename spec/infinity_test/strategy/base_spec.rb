require 'spec_helper'
require 'ostruct'

module InfinityTest
  module Strategy
    describe Base do
      let(:subject) { Base.new(InfinityTest::Core::Base) }

      describe ".subclasses" do
        it "should have rvm, rbenv, rubydefault and autodiscover as subclasses" do
          Base.subclasses.should include(Rbenv, Rvm, RubyDefault, AutoDiscover)
        end
      end

      describe ".sort_by_priority" do
        let(:low_priority) { OpenStruct.new(:priority => :very_low) }
        let(:high_priority) { OpenStruct.new(:priority => :high) }
        let(:normal_priority) { OpenStruct.new(:priority => :normal) }
        let(:regular_priority) { OpenStruct.new(:priority => :regular) }

        it "should sort the subclasses by the high priority first" do
          mock(Base).subclasses { [ low_priority, high_priority, regular_priority, normal_priority] }
          Base.sort_by_priority.should == [high_priority, normal_priority, regular_priority, low_priority]
        end
      end

      describe ".priority" do
        it "should return middle priority as default" do
          Base.priority.should equal :normal
        end
      end

      describe "#bundle_exec" do
        it "should return the params with the bundle exec if have a Gemfile and run with bundler" do
          mock(subject).has_gemfile? { true }
          mock(subject.base).using_bundler? { true }
          subject.bundle_exec('ruby -Ilib foo.rb').should == 'bundle exec ruby -Ilib foo.rb'
        end

        it "should return the same params if don't have a Gemfile and run with bundler" do
          mock(subject).has_gemfile? { false }
          subject.bundle_exec('ruby -Ilib foo.rb').should == 'ruby -Ilib foo.rb'
        end

        it "should return the same params if have a Gemfile but not rnu with bundler" do
          mock(subject).has_gemfile? { true }
          mock(subject.base).using_bundler? { false }
          subject.bundle_exec('ruby -Ilib foo.rb').should == 'ruby -Ilib foo.rb'
        end
      end

      describe "#command_builder" do
        it "should be instance of CommandBuilder" do
          subject.command_builder.should be_instance_of(Core::CommandBuilder)
        end
      end

      describe "#has_gemfile?" do
        it "should return true if gemfile exists" do
          mock(File).exist?(File.expand_path('./Gemfile')) { true }
          subject.should have_gemfile
        end

        it "should return false if gemfile don't exists" do
          mock(File).exist?(File.expand_path('./Gemfile')) { false }
          subject.should_not have_gemfile
        end
      end

      describe "#run!" do
        it "should raise Not Implemented Error" do
          lambda {
            subject.run!
          }.should raise_exception(NotImplementedError)
        end
      end

      describe "#strategy_name" do
        it "should return the name of the strategy" do
          Rvm.strategy_name.should be :rvm
        end

        it "should return the name of the strategy as undercore" do
          RubyDefault.strategy_name.should be :ruby_default
        end
      end

      describe ".run?" do
        it "should raise Not Implemented Error" do
          lambda {
            Base.run?
          }.should raise_exception(NotImplementedError)
        end
      end
    end
  end
end
