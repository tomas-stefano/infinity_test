require "spec_helper"

module InfinityTest
  module Strategy
    describe RubyDefault do
      let(:base) { BaseFixture.new }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { RubyDefault.new(continuous_test_server) }
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

      describe '#run!' do
        before { base.test_framework = :rspec }

        it 'returns the command' do
          subject.run!.should eq 'ruby -S rspec spec'
        end
      end
    end
  end
end