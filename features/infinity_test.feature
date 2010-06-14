Feature: Infinity test
  In order to continuous testing
  As a user
  I want to test my app/gem with rapid feedback

  Scenario: Run with cucumber
    When I run "ruby ../../bin/infinity_test --cucumber"
    Then I should see "Style: Cucumber"
    And I should see "ruby"
    And I should see "cucumber"
    And I should not see "rspec"
  
  Scenario: Run with Rspec
    When I run "ruby ../../bin/infinity_test --rspec"
	Then I should see "Style: Rspec"
	And I should see "ruby"
	And I should see "rspec"
	And I should not see "cucumber"
  
  
  