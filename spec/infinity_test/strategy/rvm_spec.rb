require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      subject { Rvm.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true if the user has RVM installed in users home" do
          expect(Rvm).to receive(:installed_users_home?).and_return(true)
          expect(Rvm).to be_run
        end

        it "returns true if the user has RVM installed system wide" do
          expect(Rvm).to receive(:installed_users_home?).and_return(false)
          expect(Rvm).to receive(:installed_system_wide?).and_return(true)
          expect(Rvm).to be_run
        end

        it "returns false if the user does not have RVM installed" do
          expect(Rvm).to receive(:installed_users_home?).and_return(false)
          expect(Rvm).to receive(:installed_system_wide?).and_return(false)
          expect(Rvm).not_to be_run
        end
      end
    end
  end
end
