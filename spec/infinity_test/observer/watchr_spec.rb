require 'spec_helper'

module InfinityTest
  module Observer
    describe Watchr do
      let(:continuous_server) { double }
      subject { Watchr.new(continuous_server)}
      it_should_behave_like 'an infinity test observer'

      describe "#observer" do
        it "is instance of watchr script" do
          expect(subject.observer).to be_instance_of(::Watchr::Script)
        end
      end

      describe "#watch" do
        it "passes the args to the observer" do
          expect(subject.observer).to receive(:watch).with('lib')
          subject.watch(:lib)
        end
      end

      describe "#watch_dir" do
        it "passes the pattern to the observer" do
          expect(subject.observer).to receive(:watch).with("^spec/*/(.*).rb")
          subject.watch_dir(:spec)
        end

        it "passes the pattern and the extension to the observer" do
          expect(subject.observer).to receive(:watch).with("^spec/*/(.*).py")
          subject.watch_dir(:spec, :py)
        end
      end

      describe "#start" do
        it "initializes a watchr controller passing the #observer" do
          handler_class = double
          handler = double
          controller = double
          allow(::Watchr).to receive(:handler).and_return(handler_class)
          expect(handler_class).to receive(:new).and_return(handler)
          expect(::Watchr::Controller).to receive(:new).with(subject.observer, handler).and_return(controller)
          expect(controller).to receive(:run).and_return(:running)
          expect(subject.start).to equal :running
        end
      end
    end
  end
end
