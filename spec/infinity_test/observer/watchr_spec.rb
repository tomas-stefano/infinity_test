require 'spec_helper'

module InfinityTest
  module Observer
    describe Watchr do
      it_should_behave_like 'an infinity test observer'

      describe "#observer" do
        it "should be instance of watchr script" do
          subject.observer.should be_instance_of(::Watchr::Script)
        end
      end

      describe "#start" do
        it "should initialize an watchr controller passing the #observer" do
          handler = mock
          controller = controller
          mock(::Watchr.handler).new { handler }
          mock(::Watchr::Controller).new(subject.observer, handler) { controller }
          mock(controller).run { :running }
          subject.start.should equal :running
        end
      end
    end
  end
end