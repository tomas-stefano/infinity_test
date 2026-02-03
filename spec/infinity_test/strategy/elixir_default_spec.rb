require "spec_helper"

module InfinityTest
  module Strategy
    describe ElixirDefault do
      let(:base) { BaseFixture.new }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { ElixirDefault.new(continuous_test_server) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true when mix.exs exists" do
          allow(File).to receive(:exist?).with('mix.exs').and_return(true)
          expect(ElixirDefault).to be_run
        end

        it "returns false when mix.exs does not exist" do
          allow(File).to receive(:exist?).with('mix.exs').and_return(false)
          expect(ElixirDefault).not_to be_run
        end
      end

      describe '#run!' do
        before { base.test_framework = :ex_unit }

        it 'returns the mix test command' do
          expect(subject.run!).to eq 'mix test test'
        end

        context 'with specific options' do
          before do
            Core::Base.specific_options = '--trace'
          end

          after do
            Core::Base.specific_options = ''
          end

          it 'includes the options' do
            expect(subject.run!).to eq 'mix test test --trace'
          end
        end
      end
    end
  end
end
