require "spec_helper"

module InfinityTest
  module Strategy
    describe PythonDefault do
      let(:base) { BaseFixture.new }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { PythonDefault.new(continuous_test_server) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true when pyproject.toml exists" do
          allow(File).to receive(:exist?).with('pyproject.toml').and_return(true)
          expect(PythonDefault).to be_run
        end

        it "returns true when setup.py exists" do
          allow(File).to receive(:exist?).with('pyproject.toml').and_return(false)
          allow(File).to receive(:exist?).with('setup.py').and_return(true)
          expect(PythonDefault).to be_run
        end

        it "returns false when no Python package files exist" do
          allow(File).to receive(:exist?).with('pyproject.toml').and_return(false)
          allow(File).to receive(:exist?).with('setup.py').and_return(false)
          allow(File).to receive(:exist?).with('setup.cfg').and_return(false)
          expect(PythonDefault).not_to be_run
        end
      end

      describe '#run!' do
        before { base.test_framework = :pytest }

        it 'returns the pytest command' do
          allow(File).to receive(:exist?).with('tests').and_return(true)
          expect(subject.run!).to eq 'pytest tests'
        end

        context 'with specific options' do
          before do
            Core::Base.specific_options = '-v --tb=short'
          end

          after do
            Core::Base.specific_options = ''
          end

          it 'includes the options' do
            allow(File).to receive(:exist?).with('tests').and_return(true)
            expect(subject.run!).to eq 'pytest tests -v --tb=short'
          end
        end
      end
    end
  end
end
