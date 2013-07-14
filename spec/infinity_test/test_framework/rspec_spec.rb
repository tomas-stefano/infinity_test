require 'spec_helper'

module InfinityTest
  module TestFramework
    describe Rspec do
      it_should_behave_like 'a infinity test test framework'

      # describe "#test_dir" do
      #   it "should return spec as test dir" do
      #     subject.test_dir.should == 'spec'
      #   end
      # end
      #
      # describe "#test_helper_file" do
      #   it "should be the spec helper" do
      #     subject.test_helper_file.should == 'spec/spec_helper.rb'
      #   end
      # end

      describe "#binary" do
        it "should return rspec as binary" do
          subject.binary.should == 'rspec'
        end
      end

      # describe "#test_files" do
      #   it "should return something like an Array" do
      #     subject.test_files.should be_instance_of(Array)
      #   end
      #
      #   it "need to use the test pattern" do
      #     pending
      #   end
      # end
    end
  end
end