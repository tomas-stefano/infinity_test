Feature: Infinity test
  In order to continuous testing
  As a user
  I want to test my app/gem with rapid feedback

  Background:
    Given a file named "continuous/lib/continuous.rb" with:
    """
    class Continuous
    end
    """
    And a file named "continuous/spec/continuous_spec.rb" with:
    """
    require 'continuous'
    describe Continuous do
      it "should be true" do 
        Continuous.new.should be_true 
      end
    end
    """
    And a file named "continuous/features/continuous.feature" with:
    """
    """
  

  Scenario: Show help
    When I run "ruby ../../bin/infinity_test --help"
    Then I should see:
    """
    Usage: infinity_test [options]
	Starts a continuous test server.
            --rspec                      Rspec Framework
            --rvm-versions=rubies        Specify the Ruby Versions for Testing with several Rubies
            --help                       You're looking at it.
	"""
  
