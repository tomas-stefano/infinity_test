require 'spec_helper'

module InfinityTest
  describe ConstructCommand do
    let(:construct_command) {ConstructCommand.new}

    describe '#create' do

      before do
        construct_command.stub(:binary_for).and_return('rspec')
        construct_command.stub(:binary_name).and_return('rspec')
      end
      
      context "with one ruby to run" do
        before { application_with :rubies => "1.9.2", :test_framework => :rspec, :skip_bundler => false }
        
        it { construct_command.create.command.should have_key('1.9.2') }
        
        it 'should include the ruby version to rvm and run with bundler' do
          construct_command.should_receive(:using_bundler?).and_return(true)
          construct_command.should_receive(:test_framework).at_least(:once).and_return(TestLibrary::Rspec.new(:rubies => '1.9.2'))
          command = construct_command.create.command
          command['1.9.2'].should include("rvm 1.9.2 ruby -S bundle exec rspec")
        end
      end

      context 'on bundler' do
        it 'should run with bundler' do
          @app = application_with :rubies => 'ree', :test_framework => :rspec, :skip_bundler => false
          construct_command.should_receive(:using_bundler?).and_return(true)
          command = construct_command.create.command
          command['ree'].should include("bundle exec")
        end
        
        it 'should not run with bundler when pass skip bundler in the application' do
          app = application_with :rubies => 'ree', :test_framework => :rspec, :skip_bundler => true
          construct_command.should_receive(:run_with_bundler?).and_return(false)
          command = construct_command.create.command
          command['ree'].should_not include("bundle exec")
        end
      end
      
      context "with many rubies" do
        before { application_with :rubies => %w(ree jruby) }
        
        it 'should include all rubies version in the Hash' do
          %w(ree jruby).each do |version|
            construct_command.create.command.should have_key(version)
          end
        end
        
        it 'should include all rubies commands for each version' do
          %w(ree jruby).each do |version|
            construct_command.create.command[version].should include("rvm #{version} ruby")
          end          
        end
      end
      
      context 'with ruby options' do
        before do
          @app = application_with :rubies => '1.9.2', :specific_options => '-j', :test_framework => :test_unit
        end
        
        it 'should return with the load path' do
          construct_command.create.command['1.9.2'].should include(%{-I"lib:test"})
        end
        
        it 'should return specific options' do
          construct_command.create.command['1.9.2'].should include('-j')
        end
        
        it 'should return nothing when not pass specific options' do
          application_with :rubies => '1.9.2', :specific_options => nil
          construct_command.should_receive(:run_with_bundler?).and_return(false)
          construct_command.should_receive(:test_framework).at_least(:once).and_return(TestLibrary::Rspec.new(:rubies => '1.9.2'))
          construct_command.create.command['1.9.2'].should include('rvm 1.9.2 ruby -S rspec')
        end
      end

    end

    describe '#rubies' do
      it 'should return all rubies when application has many rubies' do
        application_with :rubies => %w(ree jruby)
        construct_command.rubies.should == "ree,jruby"
      end
      
      it 'should return the current ruby when application dont have rubies' do
        application_with :rubies => nil
        construct_command.rubies.should == RVM::Environment.current.environment_name
      end
    end
    
    describe '#ruby_options' do
      it 'should return the specific options in the string' do
        application_with :rubies => '1.9.2', :specific_options => '-Jix'
        construct_command.ruby_options.should include '-Jix'
      end
      
      it 'should not return nothing when dont have specific options and dont have defaults' do
        application_with :rubies => '1.9.2', :specific_options => {}
        construct_command.should_receive(:test_framework).at_least(:once).and_return(TestLibrary::Rspec.new(:rubies => '1.9.2'))          
        construct_command.ruby_options.should == ''
      end
    end

    describe '#files_to_run' do
      it 'should be possible to pass the test files' do
        ConstructCommand.new(:files_to_run => 'spec/models/projects_spec.rb').files_to_run.should == 'spec/models/projects_spec.rb'
      end
      
      it 'should return an empty array when not pass changed files' do
        ConstructCommand.new.files_to_run.should == []
      end
    end

    describe '#files_to_test' do
      
      it 'should call the test_files' do
        files = 'spec/models/project_spec'
        construct_command.test_framework.should_receive(:test_files).and_return(files)
        construct_command.files_to_test.should == files
      end
      
      it 'should return the changed files if have files to run' do
        construct = ConstructCommand.new(:files_to_run => 'test/unit/person_spec.rb')
        construct.files_to_test.should == 'test/unit/person_spec.rb'
      end

    end

  end
end