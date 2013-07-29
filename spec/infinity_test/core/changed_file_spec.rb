require 'spec_helper'

module InfinityTest
  describe ChangedFile do
    let(:match_data) { /(.)(.)(\d+)(\d)/.match("THX1138.") }
    let(:changed_file) { ChangedFile.new(match_data) }

    describe '#name' do
      subject { changed_file.name }

      it { should eq 'HX1138' }
    end

    describe '#path' do
      subject { changed_file.path }

      it { should eq 'H' }
    end

    describe '#match_data' do
      subject { changed_file.match_data }

      it { should be match_data }
    end
  end
end