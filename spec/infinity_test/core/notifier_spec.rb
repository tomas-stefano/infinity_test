require 'spec_helper'

module InfinityTest
  module Core
    describe Notifier do
      let(:test_framework) { double }

      subject(:notifier) { Notifier.new(test_framework: test_framework, library: :growl) }

      describe '#image' do
        before do
          expect(Core::Base).to receive(:mode).and_return(:simpson)
        end

        context 'when success tests' do
          before do
            expect(test_framework).to receive(:success?).and_return(true)
          end

          it 'returns the success image' do
            expect(notifier.image).to include 'success'
          end
        end

        context 'when pending tests' do
          before do
            expect(test_framework).to receive(:success?).and_return(false)
            expect(test_framework).to receive(:failure?).and_return(false)
          end

          it 'returns the pending image' do
            expect(notifier.image).to include 'pending'
          end
        end

        context 'when failing tests' do
          before do
            expect(test_framework).to receive(:success?).and_return(false)
            expect(test_framework).to receive(:failure?).and_return(true)
          end

          it 'returns the failure image' do
            expect(notifier.image).to include 'failure'
          end
        end
      end

      describe '#library' do
        it 'returns the primitive value' do
          expect(notifier.library).to be :growl
        end
      end

      describe '#test_message' do
        it 'respond to' do
          expect(notifier).to respond_to(:test_message)
        end
      end

      describe '#images_dir' do
        context 'when is default infinity test dir' do
          it 'returns the dir with the base mode'
        end

        context 'when is pre defined images dir' do
          it 'returns the user dir expanded path'
        end
      end
    end
  end
end