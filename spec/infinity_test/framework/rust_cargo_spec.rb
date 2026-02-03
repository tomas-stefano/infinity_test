require 'spec_helper'

module InfinityTest
  module Framework
    describe RustCargo do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'tests', test_helper_file: 'Cargo.toml') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { RustCargo.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(File).to receive(:directory?).with('tests').and_return(true)
        end

        it "adds heuristics for src, tests, and Cargo.toml" do
          expect(observer).to receive(:watch_dir).with(:src, :rs)
          expect(observer).to receive(:watch_dir).with('tests', :rs)
          expect(observer).to receive(:watch).with('Cargo.toml')
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
        let(:changed_file) { double('ChangedFile', name: 'src/user.rs', path: 'user') }

        it "runs tests matching the module name" do
          expect(continuous_test_server).to receive(:rerun_strategy).with('user')
          subject.run_module_tests(changed_file)
        end

        context "when lib.rs is changed" do
          let(:lib_file) { double('ChangedFile', name: 'src/lib.rs', path: 'lib') }

          it "runs all tests" do
            expect(subject).to receive(:run_all)
            subject.run_module_tests(lib_file)
          end
        end

        context "when main.rs is changed" do
          let(:main_file) { double('ChangedFile', name: 'src/main.rs', path: 'main') }

          it "runs all tests" do
            expect(subject).to receive(:run_all)
            subject.run_module_tests(main_file)
          end
        end
      end

      describe "#run_integration_test" do
        let(:changed_file) { double('ChangedFile', name: 'tests/integration_test.rs') }

        it "runs the specific integration test" do
          expect(continuous_test_server).to receive(:rerun_strategy).with('--test integration_test')
          subject.run_integration_test(changed_file)
        end
      end

      describe ".run?" do
        it "returns true if Cargo.toml exists and is not a Rocket project" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:read).with('Cargo.toml').and_return('[dependencies]')
          expect(RustCargo).to be_run
        end

        it "returns false if Cargo.toml does not exist" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(false)
          expect(RustCargo).not_to be_run
        end

        it "returns false if it is a Rocket project" do
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(File).to receive(:read).with('Cargo.toml').and_return('rocket = "0.5"')
          expect(RustCargo).not_to be_run
        end
      end
    end
  end
end
