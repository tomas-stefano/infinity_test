require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      subject { Rvm.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "should return true if the user had the RVM installed in users home" do
          mock(Rvm).installed_users_home? { true }
          Rvm.should be_run
        end

        it "should return true if the user had the RVM installed in system wid" do
          mock(Rvm).installed_users_home? { false }
          mock(Rvm).installed_system_wide? { true }
          Rvm.should be_run
        end

        it "should return false if the user don't had the RVM installed in users home" do
          mock(Rvm).installed_users_home? { false }
          mock(Rvm).installed_system_wide? { false }
          Rvm.should_not be_run
        end
      end
    end
  end
end