require 'spec_helper'

module InfinityTest
  module Framework
    describe Django do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'tests', test_helper_file: 'tests/conftest.py') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Django.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(subject).to receive(:watch_django_apps)
          allow(File).to receive(:directory?).with('tests').and_return(true)
          allow(File).to receive(:exist?).with('tests/conftest.py').and_return(true)
        end

        it "adds heuristics for django apps, test, and conftest" do
          expect(subject).to receive(:watch_django_apps)
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

      describe "#watch_django_apps" do
        context "when Django apps exist" do
          before do
            allow(Dir).to receive(:glob).with('*').and_return(['myapp', 'accounts', 'tests'])
            allow(File).to receive(:directory?).with('myapp').and_return(true)
            allow(File).to receive(:directory?).with('accounts').and_return(true)
            allow(File).to receive(:directory?).with('tests').and_return(true)
            allow(File).to receive(:exist?).with('myapp/models.py').and_return(true)
            allow(File).to receive(:exist?).with('myapp/views.py').and_return(false)
            allow(File).to receive(:exist?).with('myapp/apps.py').and_return(false)
            allow(File).to receive(:exist?).with('accounts/models.py').and_return(false)
            allow(File).to receive(:exist?).with('accounts/views.py').and_return(true)
            allow(File).to receive(:exist?).with('accounts/apps.py').and_return(false)
          end

          it "watches Django app directories" do
            expect(observer).to receive(:watch_dir).with('myapp', :py)
            expect(observer).to receive(:watch_dir).with('accounts', :py)
            subject.watch_django_apps
          end
        end
      end

      describe ".run?" do
        context "when manage.py exists with Django" do
          before do
            allow(File).to receive(:exist?).with('manage.py').and_return(true)
            allow(File).to receive(:read).with('manage.py').and_return("os.environ.setdefault('DJANGO_SETTINGS_MODULE'")
          end

          it "returns true" do
            expect(Django).to be_run
          end
        end

        context "when manage.py does not exist" do
          before do
            allow(File).to receive(:exist?).with('manage.py').and_return(false)
          end

          it "returns false" do
            expect(Django).not_to be_run
          end
        end

        context "when manage.py exists but is not Django" do
          before do
            allow(File).to receive(:exist?).with('manage.py').and_return(true)
            allow(File).to receive(:read).with('manage.py').and_return("print('hello')")
          end

          it "returns false" do
            expect(Django).not_to be_run
          end
        end
      end
    end
  end
end
