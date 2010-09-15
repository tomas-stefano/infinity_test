# Infinity Test


Infinity Test is a continuous testing library and a flexible alternative to Autotest, 
using Watchr library with Rspec OR Test::Unit AND Cucumber with RVM funcionality,
giving the possibility to test with all <b>Rubies</b> that you have in your RVM configuration.

## To Infinity and Beyond!

<div style="width:240px; padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="http://github.com/tomas-stefano/infinity_test/raw/master/to_infinity_and_beyond.png" alt="Infinity Test" />
  <p style="text-align:center"> Photo taken by <a href="http://www.mixed-metaphor.org/fan/buzz/" title="buzz-light-year"> this site </a></p>
</div>

## Install

*   The Infinity Test gem don't have a version, but <b>is looking for contributors</b>. =]

This gem will be released in September 17.

## Running Tests only in one ruby

With Rspec:

    infinity_test --rspec

With Rspec and Cucumber:

    infinity_test --rspec --cucumber

With Test::Unit:

	infinity_test --test-unit

With Test::Unit and Cucumber:

    infinity_test --test-unit --cucumber

## Running Tests with many Rubies

With Rspec:

    infinity_test --rspec --rubies=1.8.7,jruby,1.9.2,ree

Or with Test::Unit:

    infinity_test --test-unit --rubies=1.8.7,jruby,ree,1.9.2

If you like to add cucumber too:

    infinity_test --rspec --rubies=1.8.7,jruby,1.9.2  --cucumber

    infinity_test --test-unit --rubies=1.8.7,jruby,1.9.2  --cucumber

<b>And you are ready to Test with all ruby versions your Rspec or Test::Unit Suite and Cucumber Suite with Autotest-like Behavior.</b>

## Configuration file

### Notification Frameworks

*   Growl <b>Just FOR NOW</b>

### Simple Domain Specific Language for Configuration file

Create the global file or project file called:

   `~/.infinity_test or .infinity_test`

<b>Note:</b> The project file will override the configuration of global file if have the same options!.

      # ~/.infinity_test or .infinity_test
      
      infinity_test do
      
        notifications :growl do
          on :sucess,  :show_image => :default  # or :show_image => 'Path/To/My/Image.png'
          on :failure, :show_image => :default  # or :show_image => 'Path/To/My/Image.png'
        end
        
        use :rubies => %w(1.9.1 jruby 1.9.2 ree), :test_framework => :rspec, :cucumber => true
        
        before_run do
          clear :terminal
        end
        
        after_run do
          puts 'Finished!'
        end
      
      end

* The notification receives a block with contain that images that you want dysplay.

*  The rubies options accept any ruby that you have installed via RVM.

<b>Obs.: If you use rspec and cucumber make sure that you have Rspec and Cucumber installed for each :rubies option.</b>

*  The options for test_framework in the #use method are:

   * Rspec  - :rspec
   * Test::Unit - :test_unit

* If you want cucumber just add `:cucumber => true` to #use method.

* The #before_run method run before all tests.

* The #after_run method run after all tests.

## You Like it the Idea?

<b>So make a fork and start contributing =].</b>

## You have a Feature request or Fix?

<b>Contact me in Github and let's talk! =] </b>

## TODO

* Make work the system notification in Growl
* Make work with cucumber
* Make a new strategy for search the paths for each ruby (Is too slow!)
* Working in focus files and run only the modified file (Strategies for Test::Unit, Rspec and Cucumber)

# Acknowledgments

* Thanks to watchr library.
* Thanks to Waynee Seguin and the RVM.
