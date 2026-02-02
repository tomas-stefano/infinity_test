require 'spec_helper'

module InfinityTest
  module Observer
    describe Base do
      let(:continuous_server) { double }
      subject { Base.new(continuous_server) }

      describe "#initialize" do
        it "sets the continuous_test_server" do
          expect(subject.continuous_test_server).to eq(continuous_server)
        end
      end

      describe "#watch" do
        it "raises NotImplementedError" do
          expect { subject.watch('pattern') {} }.to raise_error(NotImplementedError)
        end
      end

      describe "#watch_dir" do
        it "raises NotImplementedError" do
          expect { subject.watch_dir(:lib, :rb) {} }.to raise_error(NotImplementedError)
        end
      end

      describe "#start" do
        it "raises NotImplementedError" do
          expect { subject.start }.to raise_error(NotImplementedError)
        end
      end

      describe "#start!" do
        it "calls signal and start" do
          expect(subject).to receive(:signal)
          expect(subject).to receive(:start)
          subject.start!
        end
      end

      describe "#signal" do
        it "traps INT signal" do
          expect(Signal).to receive(:trap).with('INT')
          subject.signal
        end

        context "interrupt handling logic" do
          let(:handler) do
            handler_block = nil
            allow(Signal).to receive(:trap) { |_, &block| handler_block = block }
            subject.signal
            handler_block
          end

          it "shows warning on first interrupt" do
            expect(subject).to receive(:puts).with(" Are you sure? :S ... Interrupt a second time to quit!")
            handler.call
            expect(subject.instance_variable_get(:@interrupt_at)).to be_within(1).of(Time.now)
          end

          it "exits on second interrupt within 2 seconds" do
            subject.instance_variable_set(:@interrupt_at, Time.now)
            expect(subject).to receive(:puts).with(" To Infinity and Beyond!")
            expect(subject).to receive(:exit)
            handler.call
          end

          it "resets timer if second interrupt is after 2 seconds" do
            subject.instance_variable_set(:@interrupt_at, Time.now - 3)
            expect(subject).to receive(:puts).with(" Are you sure? :S ... Interrupt a second time to quit!")
            handler.call
            expect(subject.instance_variable_get(:@interrupt_at)).to be_within(1).of(Time.now)
          end
        end
      end
    end
  end
end
