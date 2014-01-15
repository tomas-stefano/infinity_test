require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      subject { Rvm.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "should return true if the user had the RVM installed in users home" do
          Rvm.should_receive(:installed_users_home?).and_return(true)
          expect(Rvm).to be_run
        end

        it "should return true if the user had the RVM installed in system wid" do
          Rvm.should_receive(:installed_users_home?).and_return(false)
          Rvm.should_receive(:installed_system_wide?).and_return(true)
          expect(Rvm).to be_run
        end

        it "should return false if the user don't had the RVM installed in users home" do
          Rvm.should_receive(:installed_users_home?).and_return(false)
          Rvm.should_receive(:installed_system_wide?).and_return(false)
          expect(Rvm).not_to be_run
        end
      end
    end
  end
end