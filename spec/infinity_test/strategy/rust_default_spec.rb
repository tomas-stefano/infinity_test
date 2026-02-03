require "spec_helper"

module InfinityTest
  module Strategy
    describe RustDefault do
      let(:base) { BaseFixture.new }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { RustDefault.new(continuous_test_server) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true when Cargo.toml exists" do
          allow(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(RustDefault).to be_run
        end

        it "returns false when Cargo.toml does not exist" do
          allow(File).to receive(:exist?).with('Cargo.toml').and_return(false)
          expect(RustDefault).not_to be_run
        end
      end

      describe '#run!' do
        before { base.test_framework = :cargo_test }

        it 'returns the cargo test command' do
          expect(subject.run!).to eq 'cargo test'
        end

        context 'with test files specified' do
          before do
            allow(continuous_test_server).to receive(:test_files).and_return('user')
          end

          it 'includes the test name' do
            expect(subject.run!).to eq 'cargo test user'
          end
        end

        context 'with specific options' do
          before do
            Core::Base.specific_options = '-- --nocapture'
          end

          after do
            Core::Base.specific_options = ''
          end

          it 'includes the options' do
            expect(subject.run!).to eq 'cargo test -- --nocapture'
          end
        end
      end
    end
  end
end
