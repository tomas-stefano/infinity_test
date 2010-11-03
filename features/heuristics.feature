Feature: Infinity test Heuristics
  In order to add or remove the paths to monitoring
  As a user
  I want to add/remove my own patterns to monitoring changes

  Scenario: Show the default patterns to RubyGems
    When I run "ruby ../../bin/infinity_test --patterns"
    Then the output should contain:
    """
	- "^lib/*/(.*)\.rb"
	- "^spec/*/(.*)_spec.rb"
	- "^spec/*/spec_helper.rb"
  	"""
