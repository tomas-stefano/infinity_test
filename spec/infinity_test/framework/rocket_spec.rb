require 'spec_helper'

module InfinityTest
  module Framework
    describe Rocket do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'tests', test_helper_file: 'Cargo.toml') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Rocket.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(File).to receive(:directory?).with('tests').and_return(true)
          allow(File).to receive(:exist?).with('Rocket.toml').and_return(true)
        end

        it "adds heuristics for src, tests, Cargo.toml, and Rocket.toml" do
          expect(observer).to receive(:watch_dir).with(:src, :rs)
          expect(observer).to receive(:watch_dir).with('tests', :rs)
          expect(observer).to receive(:watch).with('Cargo.toml')
          expect(observer).to receive(:watch).with('Rocket.toml')
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe "#heuristics!" do
        it "appends .rs extension to hike" do
          hike = double('Hike')
          allow(subject).to receive(:hike).and_return(hike)
          allow(File).to receive(:directory?).with('tests').and_return(true)
          expect(hike).to receive(:append_extension).with('.rs')
          expect(hike).to receive(:append_path).with('tests')
          allow(subject).to receive(:heuristics)
          subject.heuristics!
        end
      end

      describe "#run_module_tests" do
        let(:changed_file) { double('ChangedFile', name: 'src/routes.rs', path: 'routes') }

        it "runs tests matching the module name" do
          expect(continuous_test_server).to receive(:rerun_strategy).with('routes')
          subject.run_module_tests(changed_file)
        end
      end

      describe ".run?" do
        it "returns true if Cargo.toml exists with rocket dependency" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:read).with('Cargo.toml').and_return('rocket = "0.5"')
          expect(Rocket).to be_run
        end

        it "returns false if Cargo.toml does not exist" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(false)
          expect(Rocket).not_to be_run
        end

        it "returns false if Cargo.toml does not contain rocket" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:read).with('Cargo.toml').and_return('[dependencies]')
          expect(Rocket).not_to be_run
        end
      end
    end
  end
end
