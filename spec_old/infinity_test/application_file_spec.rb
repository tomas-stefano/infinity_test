require 'spec_helper'

module InfinityTest
  describe ApplicationFile do
    let(:application_file) { ApplicationFile.new(:test => TestLibrary::Rspec.new) }
    let(:application_file_with_test_unit) { ApplicationFile.new(:test => TestLibrary::TestUnit.new)}
    let(:application) { Application.new }
    
    describe '#search' do
      before do
        @current_dir = Dir.pwd
      end
      
      it 'should return all files when pass all files in options' do
        wood_library do
          application_file.search(:all => :files).should == "spec/wood_spec.rb"
        end
      end
      
      it 'should return all files in dir specified as string' do
        rails_app do
          application_file.search(:all => :files, :in_dir => 'spec/models').should == "spec/models/project_spec.rb spec/models/task_spec.rb"
        end
      end
      
      it 'should return all files in dir specified as symbol' do
        rails_app do
          application_file.search(:all => :files, :in_dir => :integration).should == "spec/integration/person_spec.rb spec/integration/song_spec.rb"
        end
      end
      
      it 'should return all files in the dirs specified as array' do
        rails_app do
          application_file.search(:all => :files, :in_dir => [:helpers, :models]).should == "spec/helpers/people_helper_spec.rb spec/models/project_spec.rb spec/models/task_spec.rb"
        end
      end
      
      it 'should return all files in the tests dir specified' do
        rails_app do
          application_file_with_test_unit.search(:all => :files, :in_dir => :unit).should == "test/unit/person_test.rb"
        end
      end
      
      it 'should return the same file if the options is Matchdata' do
        rails_app do
          #<MatchData "test/unit/street_test.rb" 1:"unit/street">
          match_data = "test/unit/street_test.rb".match("^test/*/(.*)_test.rb")
          application_file.search(match_data).should == "test/unit/street_test.rb"
        end
      end

      it 'should return all files that match the Matchdata in the specified dir' do
        rails_app do
          #<MatchData "app/models/project.rb" 1:"project">
          match_data = "app/models/project.rb".match("^app/models/(.*)\.rb")
          application_file.search(:test_for => match_data, :in_dir => :models).should == "spec/models/project_spec.rb"
        end
      end
      
      it 'should return the test file that matchs with the file modified' do
        rubygems_lib do
          #<MatchData "lib/library.rb" 1:"library">
          match_data = "lib/library.rb".match("^lib/*/(.*)\.rb")
          application_file_with_test_unit.search(:test_for => match_data).should == "test/library_test.rb"
        end
      end
      
      it 'should return the test file that match with the matchdata in a dir specified' do
        rails_app do
          matchdata = "app/controllers/people.rb".match("^app/controllers/(.*)\.rb")
          application_file_with_test_unit.search(:test_for => matchdata, :in_dir => :functional).should == 'test/functional/people_test.rb'
        end
      end

    end
  end
end