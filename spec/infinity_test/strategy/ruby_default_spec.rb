require "spec_helper"

module InfinityTest
  module Strategy
    describe RubyDefault do
      subject { RubyDefault.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "should return true when don't pass any ruby versions to run tests" do
          Core::Base.stub(:rubies).and_return([])
          RubyDefault.should be_run
        end

        it "should return false when pass some ruby version to run tests" do
          Core::Base.stub(:rubies).and_return(['ree', 'jruby'])
          RubyDefault.should_not be_run
        end
      end

      describe ".priority" do
        it "should be the high priority" do
          RubyDefault.priority.should equal :high
        end
      end
    end
  end
end