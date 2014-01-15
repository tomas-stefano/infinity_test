require 'spec_helper'

module InfinityTest
  module Core
    describe Notifier do
      describe '#notify' do
        let(:growl) do
          mock
        end

        let(:notifier) do
          Notifier.new(notify_library: :growl, message: 'To infinity and beyond!', image: 'example.png')
        end

        it 'call the notify library passing the right message' do
          expect(notifier).to receive(:growl).and_return(growl)
          expect(growl).to receive(:message).with('To infinity and beyond!').and_return(growl)
          expect(growl).to receive(:image).with('example.png')
          notifier.notify
        end
      end
    end
  end
end