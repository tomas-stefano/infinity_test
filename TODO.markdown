Future
======

- Big refactoring
- Fix heuristics for Rails/Test Unit users
- Support Cucumber
- Run with failed tests (Focus mode!!)
- Put a method in the configuration file called #ignore like:

Example:

     ignore :folders => %w(), :files => %w()

- Put some methods in the configuration file like: #all_tests_pass?, #all_tests_pass_in_ruby? like:

Example:

	after(:all) do
      if all_tests_pass?
        # do something
      end
               
      if all_tests_pass_in_ruby?('1.8.7') 
        # do something
      end
	end

Bugs
====

- Coloring the output with Test::Unit (maybe using RedGreen)
