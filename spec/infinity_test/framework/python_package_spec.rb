require 'spec_helper'

module InfinityTest
  module Framework
    describe PythonPackage do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'tests', test_helper_file: 'tests/conftest.py') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { PythonPackage.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(subject).to receive(:watch_python_dirs)
          allow(File).to receive(:exist?).with('tests/conftest.py').and_return(true)
        end

        it "adds heuristics for python dirs, test, and conftest" do
          expect(subject).to receive(:watch_python_dirs)
          expect(observer).to receive(:watch_dir).with('tests', :py)
          expect(observer).to receive(:watch).with('tests/conftest.py')
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe "#heuristics!" do
        it "appends .py extension to hike" do
          hike = double('Hike')
          allow(subject).to receive(:hike).and_return(hike)
          expect(hike).to receive(:append_extension).with('.py')
          expect(hike).to receive(:append_path).with('tests')
          allow(subject).to receive(:heuristics)
          subject.heuristics!
        end
      end

      describe "#watch_python_dirs" do
        context "when src directory exists" do
          before do
            allow(File).to receive(:directory?).with('src').and_return(true)
            allow(File).to receive(:directory?).with('lib').and_return(false)
            allow(Dir).to receive(:glob).with('*/__init__.py').and_return([])
            allow(Dir).to receive(:glob).with('src/**/*.py').and_return(['src/mypackage/utils.py'])
          end

          it "watches the src directory" do
            expect(observer).to receive(:watch_dir).with('src', :py)
            subject.watch_python_dirs
          end
        end

        context "when package directory with __init__.py exists" do
          before do
            allow(File).to receive(:directory?).with('src').and_return(false)
            allow(File).to receive(:directory?).with('lib').and_return(false)
            allow(Dir).to receive(:glob).with('*/__init__.py').and_return(['mypackage/__init__.py'])
            allow(File).to receive(:directory?).with('mypackage').and_return(true)
            allow(Dir).to receive(:glob).with('mypackage/**/*.py').and_return(['mypackage/utils.py'])
          end

          it "watches the package directory" do
            expect(observer).to receive(:watch_dir).with('mypackage', :py)
            subject.watch_python_dirs
          end
        end
      end

      describe ".run?" do
        it "returns true if pyproject.toml exists" do
          expect(File).to receive(:exist?).with('pyproject.toml').and_return(true)
          expect(PythonPackage).to be_run
        end

        it "returns true if setup.py exists" do
          expect(File).to receive(:exist?).with('pyproject.toml').and_return(false)
          expect(File).to receive(:exist?).with('setup.py').and_return(true)
          expect(PythonPackage).to be_run
        end

        it "returns true if setup.cfg exists" do
          expect(File).to receive(:exist?).with('pyproject.toml').and_return(false)
          expect(File).to receive(:exist?).with('setup.py').and_return(false)
          expect(File).to receive(:exist?).with('setup.cfg').and_return(true)
          expect(PythonPackage).to be_run
        end

        it "returns false if no Python package files exist" do
          expect(File).to receive(:exist?).with('pyproject.toml').and_return(false)
          expect(File).to receive(:exist?).with('setup.py').and_return(false)
          expect(File).to receive(:exist?).with('setup.cfg').and_return(false)
          expect(PythonPackage).not_to be_run
        end
      end
    end
  end
end
