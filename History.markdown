v0.2.0
==============================

Features
--------

- Make possible to run callbacks in each ruby.

   Example:

      # ~/.infinity_test or ./.infinity_test
      infinity_test do
       before(:each_ruby) do |environment|
         environment.ruby('some_ruby_file') # run a ruby file in each ruby that you setup
         environment.rake('Rakefile', 'compile') # run rake compile in each ruby that you setup
       end

       after(:each_ruby) do |environment|
         ...
       end

       before(:all) do
         clear :terminal
       end

       after(:all) do
         ...
       end
      end

Bugfix
------

* When not have notifications framework do nothing instead raise an Exception (thanks to Nelson Minor Haraguchi)
* When you don't use a block in #notifications method in .infinity_test, then Infinity Test will use the simpson default images

v0.1.0
======

* Support Rspec 2 or Rspec 1.3.
* Put some images to show in the notifications.
* Create the hooks in before all the test and after all tests.
* Create the notifications DSL for the .infinity_test file.
* Possible to run with Test::Unit or Rspec with RVM.