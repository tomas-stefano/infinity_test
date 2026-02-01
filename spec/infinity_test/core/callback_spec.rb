require 'spec_helper'

module InfinityTest
  module Core
    describe Callback do
      describe '#initialize' do
        it 'creates a before callback with default scope' do
          callback = Callback.new(:before) { 'test' }
          expect(callback.type).to eq :before
          expect(callback.scope).to eq :all
        end

        it 'creates an after callback with custom scope' do
          callback = Callback.new(:after, :each_ruby) { 'test' }
          expect(callback.type).to eq :after
          expect(callback.scope).to eq :each_ruby
        end

        it 'raises error for invalid scope' do
          expect { Callback.new(:before, :invalid) { 'test' } }.to raise_error(ArgumentError)
        end
      end

      describe '#call' do
        it 'executes the block without arguments' do
          result = nil
          callback = Callback.new(:before) { result = 'executed' }
          callback.call
          expect(result).to eq 'executed'
        end

        it 'executes the block with environment argument' do
          result = nil
          callback = Callback.new(:before, :each_ruby) { |env| result = env[:ruby_version] }
          callback.call(ruby_version: '3.0.0')
          expect(result).to eq '3.0.0'
        end
      end

      describe '#before?' do
        it 'returns true for before callbacks' do
          callback = Callback.new(:before) { 'test' }
          expect(callback).to be_before
        end

        it 'returns false for after callbacks' do
          callback = Callback.new(:after) { 'test' }
          expect(callback).not_to be_before
        end
      end

      describe '#after?' do
        it 'returns true for after callbacks' do
          callback = Callback.new(:after) { 'test' }
          expect(callback).to be_after
        end

        it 'returns false for before callbacks' do
          callback = Callback.new(:before) { 'test' }
          expect(callback).not_to be_after
        end
      end

      describe '#all?' do
        it 'returns true for all scope' do
          callback = Callback.new(:before, :all) { 'test' }
          expect(callback).to be_all
        end

        it 'returns false for each_ruby scope' do
          callback = Callback.new(:before, :each_ruby) { 'test' }
          expect(callback).not_to be_all
        end
      end

      describe '#each_ruby?' do
        it 'returns true for each_ruby scope' do
          callback = Callback.new(:before, :each_ruby) { 'test' }
          expect(callback).to be_each_ruby
        end

        it 'returns false for all scope' do
          callback = Callback.new(:before, :all) { 'test' }
          expect(callback).not_to be_each_ruby
        end
      end
    end
  end
end
