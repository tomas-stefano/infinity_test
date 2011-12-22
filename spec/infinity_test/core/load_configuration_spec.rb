require "spec_helper"

module InfinityTest
  describe LoadConfiguration do
    describe "#load!" do
      it "should load global file and project file" do
        mock(subject).load_global_file!  { true }
        mock(subject).load_project_file! { true }
        subject.load!
      end
    end

    describe "#load_global_file!" do
      it "should load the global file" do
        subject.global_file = 'foo'
        mock(subject).load_file('foo') { true }
        subject.load_global_file!
      end
    end

    describe "#load_project_file!" do
      it "should load the project file" do
        subject.project_file = 'bar'
        mock(subject).load_file('bar') { true }
        subject.load_project_file!
      end
    end

    describe "#load_file" do
      it "should load if file exist" do
        mock(File).exist?('bar') { true }
        mock(subject).load('bar') { true }
        subject.load_file('bar').should be_true
      end

      it "should not load if file dont exist" do
        mock(File).exist?('baz') { false }
        mock(subject).load('baz').never
        subject.load_file('baz')
      end
    end
  end
end