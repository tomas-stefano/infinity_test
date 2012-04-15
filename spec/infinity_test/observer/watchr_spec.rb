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

      describe "#watch" do
        it "should pass the args to the observer" do
          mock(subject.observer).watch('lib')
          subject.watch(:lib)
        end
      end

      describe "#watch_dir" do
        it "should pass the pattern to the observer" do
          mock(subject.observer).watch("^spec/*/(.*).rb")
          subject.watch_dir(:spec)
        end

        it "should pass the pattern and the extension to the observer" do
          mock(subject.observer).watch("^spec/*/(.*).py")
          subject.watch_dir(:spec, :py)
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