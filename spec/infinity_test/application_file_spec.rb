require 'spec_helper'

module InfinityTest
  describe ApplicationFile do
    let(:application_file) { ApplicationFile.new(:test => TestLibrary::Rspec.new, :app => ApplicationLibrary::Rails.new) }
    let(:application) { Application.new }
    
    describe '#search' do
      before do
        @current_dir = Dir.pwd
      end
      
      it 'should return all files when pass all files in options' do
        wood_library do
          application_file.search(:all => :files).should == ["spec/wood_spec.rb"]
        end
      end
      
      it 'should return all files in dir specified as string' do
        rails_app do
          application_file.search(:all => :files, :in_dir => 'spec/models').should == ["spec/models/project_spec.rb", "spec/models/task_spec.rb"]
        end
      end
      
      it 'should return all files in dir specified as symbol' do
        rails_app do
          application_file.search(:all => :files, :in_dir => :integration).should == ["spec/integration/person_spec.rb", "spec/integration/song_spec.rb"]
        end
      end
      
      it 'should return all files in the dirs specified as array' do
        rails_app do
          application_file.search(:all => :files, :in_dir => [:helpers, :models]).should == ["spec/helpers/people_helper_spec.rb", "spec/models/project_spec.rb", "spec/models/task_spec.rb"]
        end
      end
      
    end
  end
end