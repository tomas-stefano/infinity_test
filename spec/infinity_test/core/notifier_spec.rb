require 'spec_helper'

module InfinityTest
  module Core
    describe Notifier do
      describe '#notify' do
        let(:growl) do
          mock
        end

        let(:notifier) do
          Notifier.new(notify_library: :growl, message: 'To infinity and beyond!')
        end

        it 'call the notify library passing the right message' do
          notifier.should_receive(:growl).and_return(growl)
          growl.should_receive(:message).with('To infinity and beyond!')
          notifier.notify
        end
      end
    end
  end
end