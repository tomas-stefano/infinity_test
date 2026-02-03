require 'spec_helper'

module InfinityTest
  module Framework
    describe FastApi do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'tests', test_helper_file: 'tests/conftest.py') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { FastApi.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(subject).to receive(:watch_fastapi_dirs)
          allow(File).to receive(:exist?).with('tests/conftest.py').and_return(true)
        end

        it "adds heuristics for fastapi dirs, test, and conftest" do
          expect(subject).to receive(:watch_fastapi_dirs)
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

      describe "#watch_fastapi_dirs" do
        context "when app directory exists" do
          before do
            allow(File).to receive(:directory?).with('app').and_return(true)
            allow(File).to receive(:directory?).with('src').and_return(false)
            allow(File).to receive(:directory?).with('routers').and_return(false)
            allow(File).to receive(:directory?).with('api').and_return(false)
            allow(File).to receive(:directory?).with('endpoints').and_return(false)
            allow(File).to receive(:directory?).with('.').and_return(true)
            allow(Dir).to receive(:glob).with('*.py').and_return(['main.py'])
            allow(Dir).to receive(:glob).with('app/**/*.py').and_return(['app/main.py'])
            allow(Dir).to receive(:glob).with('./**/*.py').and_return(['main.py'])
          end

          it "watches the app directory" do
            expect(observer).to receive(:watch_dir).with('app', :py)
            expect(observer).to receive(:watch_dir).with('.', :py)
            subject.watch_fastapi_dirs
          end
        end
      end

      describe ".run?" do
        context "when app/main.py exists with FastAPI" do
          before do
            allow(File).to receive(:exist?).with('app/main.py').and_return(true)
            allow(File).to receive(:read).with('app/main.py').and_return('from fastapi import FastAPI')
          end

          it "returns true" do
            expect(FastApi).to be_run
          end
        end

        context "when main.py exists with FastAPI" do
          before do
            allow(File).to receive(:exist?).with('app/main.py').and_return(false)
            allow(File).to receive(:exist?).with('main.py').and_return(true)
            allow(File).to receive(:read).with('main.py').and_return('app = FastAPI()')
          end

          it "returns true" do
            expect(FastApi).to be_run
          end
        end

        context "when no FastAPI project" do
          before do
            allow(File).to receive(:exist?).with('app/main.py').and_return(false)
            allow(File).to receive(:exist?).with('main.py').and_return(false)
            allow(File).to receive(:exist?).with('src/main.py').and_return(false)
          end

          it "returns false" do
            expect(FastApi).not_to be_run
          end
        end
      end
    end
  end
end
