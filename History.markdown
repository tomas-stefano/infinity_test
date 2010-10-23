In Development
==============

Features
--------

- Support Bundler: 
The InfinityTest try to discover If the user have a Gemfile in the project root and
if Gemfile exists InfinityTest will run with "bundle exec #{command}" else will run "command" normally.

Obs.: <b>In any case, you don't want this "magic" just run infinity_test with --skip-bundler flag.
Or write this in .infinity_test file:</b>

      # ~/.infinity_test or ./.infinity_test
         infinity_test do
            skip_bundler!
         end

- Support Bacon - for more information see - http://github.com/chneukirchen/bacon (thanks to Ng Tze Yang)

- Possible to setup the lib pattern, test pattern (thanks to Jason Rogers).
 
      # ~/.infinity_test or ./.infinity_test
         infinity_test do
		   before_env do |application|
             application.test_framework.test_directory_pattern = "^my_unusual_spec_directory/unit/(.*)_spec.rb"
             application.test_framework.test_pattern           = "my_unusual_spec_directory/unit/*_spec.rb"
             application.library_directory_pattern             = '^my_unusual_lib_directory/*/(.*).rb'
           end
         end

Refactoring
-----------

- Refactoring all the tests frameworks to become more easier to add a new test library

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
         environment.system('rake compile') # or with system command
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
