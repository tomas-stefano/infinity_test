require 'spec_helper'

module InfinityTest
  module Core
    describe Notifier do
      let(:test_framework) { double }

      subject(:notifier) { Notifier.new(test_framework: test_framework, library: :auto_discover) }

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
          expect(notifier.library).to be :auto_discover
        end
      end

      describe '#test_message' do
        it 'respond to' do
          expect(notifier).to respond_to(:test_message)
        end
      end

      describe '#images_dir' do
        context 'when is default infinity test dir' do
          before do
            expect(Core::Base).to receive(:mode).and_return(:simpson)
          end

          it 'returns the dir with the base mode' do
            expect(notifier.images_dir).to include '/images/simpson'
          end
        end

        context 'when is pre defined images dir' do
          before do
            expect(Core::Base).to receive(:mode).and_return('/my_images_dir')
          end

          it 'returns the user dir expanded path' do
            expect(notifier.images_dir).to eq '/my_images_dir'
          end
        end
      end

      describe '#success_image' do
        context 'when core base image is blank' do
          it 'find a image inside mode dir' do
            expect(notifier).to receive(:find_image).with(:success)
            notifier.success_image
          end
        end

        context 'when core base has a image' do
          it 'returns core base image' do
            expect(Core::Base).to receive(:success_image).and_return('some_image.png')
            expect(notifier.success_image).to eq 'some_image.png'
          end
        end
      end

      describe '#failure_image' do
        context 'when core base image is blank' do
          it 'find a image inside mode dir' do
            expect(notifier).to receive(:find_image).with(:failure)
            notifier.failure_image
          end
        end

        context 'when core base has a image' do
          it 'returns core base image' do
            expect(Core::Base).to receive(:failure_image).and_return('some_image.png')
            expect(notifier.failure_image).to eq 'some_image.png'
          end
        end
      end

      describe '#pending_image' do
        context 'when core base image is blank' do
          it 'find a image inside mode dir' do
            expect(notifier).to receive(:find_image).with(:pending)
            notifier.pending_image
          end
        end

        context 'when core base has a image' do
          it 'returns core base image' do
            expect(Core::Base).to receive(:pending_image).and_return('some_image.png')
            expect(notifier.pending_image).to eq 'some_image.png'
          end
        end
      end
    end
  end
end