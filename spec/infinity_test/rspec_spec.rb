require 'spec_helper'

module InfinityTest
  describe Rspec do
    before do
      @current_dir = Dir.pwd
    end
    
    it "should be possible to sett all rubies" do
      Rspec.new(:rubies => '1.9.1').rubies.should be == '1.9.1'
    end
    
    it "should set the rubies" do
      Rspec.new(:rubies => 'jruby,ree').rubies.should be == 'jruby,ree'
    end
    
    it "rubies should be empty when not have rubies" do
      Rspec.new.rubies.should be_empty
    end
    
    it "should have the pattern for spec directory" do
      Rspec.new.test_directory_pattern.should be == "^spec/(.*)_spec.rb"
    end
      
    describe '#rspec_path' do
      
      it "should return the bin path for rspec 1.3.0" do
        Gem.should_receive(:bin_path).with('rspec-core', 'rspec').and_raise(Gem::GemNotFoundException)
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('bin/spec')
        Rspec.new.rspec_path.should be == 'bin/spec'
      end
      
      it "should return the bin path for rspec 1.2.0" do
        Gem.should_receive(:bin_path).with('rspec-core', 'rspec').and_raise(Gem::LoadError)        
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('rspec-1.2.0-bin/spec')
        Rspec.new.rspec_path.should be == 'rspec-1.2.0-bin/spec'
      end
      
      it "should return the bin path for rspec 1.3 if not have the rspec 2.0" do
        Gem.should_receive(:bin_path).with('rspec-core', 'rspec').and_raise(LoadError)
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('rspec')
        Rspec.new.rspec_path.should be == 'rspec'
      end

      it "should return the bin path for rspec 2 if not have the rspec 1.3" do
        Gem.should_receive(:bin_path).with('rspec-core', 'rspec').and_return('rspec-beta')
        Rspec.new.rspec_path.should be == 'rspec-beta'
      end
      
    end
    
    describe '#construct_commands' do

      it "should return a Hash" do
        Rspec.new.construct_commands.should be_instance_of(Hash)
      end

      it "should return one item when not have any rubies" do
        Rspec.new.construct_commands.should have(1).item
      end

      it "should return the ruby version as the key" do
        redefine_const(:RUBY_VERSION, '1.9.1') do
          redefine_const(:JRUBY_VERSION, '1.9.1') do
            Rspec.new.construct_commands.keys.should be == ['1.9.1']
          end
        end
      end

      it "should return the ruby version as the key" do
        redefine_const(:RUBY_VERSION, '1.9.2') do
          redefine_const(:JRUBY_VERSION, '1.9.2') do
            Rspec.new.construct_commands.keys.should be == ['1.9.2']
          end
        end
      end

      it "should grab the current ruby version of the user" do
        redefine_const(:JRUBY_VERSION, 'jruby') do
          redefine_const(:RUBY_PLATFORM, 'java') do
            Rspec.new.construct_commands.keys.should be == ['jruby']
          end
        end
      end

      it "should grab the current ruby and set the ruby bin dir" do
        Rspec.new.construct_commands.values.first.should match /ruby/
      end
      
      it "should call construct_rubies_commands when have rubies" do
        rspec = Rspec.new(:rubies => '1.9.1')
        rspec.should_receive(:construct_rubies_commands)
        rspec.construct_commands
      end
      
      it "should not call construct_rubies_commands when not have rubies" do
        rspec = Rspec.new
        rspec.should_not_receive(:construct_rubies_commands)
        rspec.construct_commands
      end

    end
    
    describe '#spec_files' do
      
      let(:rspec) { Rspec.new }
      
      it "return should include the spec files" do
        Dir.chdir("#{@current_dir}/spec/factories/buzz") do
          rspec.spec_files.should be == "spec/buzz_spec.rb"
        end
      end
      
      it "return should include the spec files to test them" do
        Dir.chdir("#{@current_dir}/spec/factories/wood") do
          rspec.spec_files.should be == "spec/wood_spec.rb"
        end
      end
      
      it "return should include the spec files to test them in two level of the spec folder" do
        Dir.chdir("#{@current_dir}/spec/factories/slinky") do
          rspec.spec_files.should be == "spec/slinky/slinky_spec.rb"
        end
      end
      
    end
    
    def redefine_const(name,value)
      if Object.const_defined?(name)
        old_value = Object.const_get(name)
        Object.send(:remove_const, name)
      else
        old_value = value
      end      
      Object.const_set(name,value)
      yield
    ensure
      Object.send(:remove_const, name)
      Object.const_set(name, old_value)
    end
    
  end
end