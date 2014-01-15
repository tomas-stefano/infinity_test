require "spec_helper"

module InfinityTest
  describe LoadConfiguration do
    describe "#load!" do
      it "should load global file and project file" do
        subject.should_receive(:load_global_file!).and_return(true)
        subject.should_receive(:load_project_file!).and_return(true)
        subject.load!
      end
    end

    describe "#load_global_file!" do
      it "should load the global file" do
        subject.global_file = 'foo'
        subject.should_receive(:load_file).with('foo').and_return(true)
        subject.load_global_file!
      end
    end

    describe "#load_project_file!" do
      it "should load the project file" do
        subject.project_file = 'bar'
        subject.should_receive(:load_file).with('bar').and_return(true)
        subject.load_project_file!
      end
    end

    describe "#load_file" do
      it "should load if file exist" do
        File.should_receive(:exist?).with('bar').and_return(true)
        subject.should_receive(:load).with('bar').and_return(true)
        expect(subject.load_file('bar')).to be_true
      end

      it "should not load if file dont exist" do
        File.should_receive(:exist?).with('baz').and_return(false)
        subject.should_not_receive(:load)
        subject.load_file('baz')
      end
    end
  end
end