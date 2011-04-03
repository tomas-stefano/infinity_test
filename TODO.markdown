Future
======

- Create a Rails Generator on the fly that receives some arguments and create a ./.infinity_test file
- Support Cucumber
- Run with failed tests (Focus mode!!)
- Put some methods in the configuration file like: #all_tests_pass?, #all_tests_pass_in_ruby? like:

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
