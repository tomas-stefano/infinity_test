v2.0.0
======

This is a major release with a complete rewrite of the library, modernization of dependencies, and many new features.

Breaking Changes
----------------
- Configuration file renamed from `.infinity_test` to `INFINITY_TEST`
- Removed Bacon test framework support
- Removed Growl notification support (use notifiers gem instead)
- The #before_env method in the configuration file was removed
- The #before_run and #after_run methods were removed. Use before(:all) and after(:all) instead

New Features
------------
- **Modern Notifications**: Integration with the notifiers gem supporting:
  - osascript (macOS built-in)
  - terminal_notifier (macOS)
  - notify_send (Linux libnotify)
  - dunstify (Linux dunst)
  - auto_discover (automatic detection)
  - New CLI options: `--notifications` and `--mode` for image themes

- **Callbacks System**: Full callback support with before/after hooks
  - `before(:all)` - Run before all tests
  - `after(:all)` - Run after all tests
  - `before(:each_ruby)` - Run before each Ruby version
  - `after(:each_ruby)` - Run after each Ruby version

- **Multi-Ruby Support**:
  - RVM strategy: Run tests across multiple Ruby versions with gemset support
  - RbEnv strategy: Run tests with RBENV_VERSION environment variable
  - RubyDefault strategy: Run on current Ruby version

- **Just Watch Mode**: `--just-watch` (-j) option to skip initial test run
  - Useful for large applications where startup is slow
  - Only watches for file changes and runs tests on change

- **Focus Mode**: `--focus` (-f) option for running specific tests
  - `--focus failures` - Run only previously failed tests
  - `--focus path/to/spec.rb` - Run only specified file

- **Framework Heuristics**:
  - Rails: Watches models, controllers, helpers, mailers, jobs, lib
  - Padrino: Similar to Rails with Padrino-specific paths
  - Rubygems: Watches lib and test/spec directories

- **Auto Discovery Priority**: Smart prioritization when auto-discovering
  - Strategies: RVM > RbEnv > RubyDefault
  - Frameworks: Rails > Padrino > Rubygems
  - Test Frameworks: RSpec > Test::Unit

- **Test Framework Improvements**:
  - Complete Test::Unit/Minitest implementation with output parsing
  - RSpec improvements: test_dir=, pending?, and .run? methods

- **Modern File Watching**:
  - Listen gem (default) - Event-driven, uses native OS notifications
  - Filewatcher gem - Polling-based, works everywhere including VMs/NFS

- **AI Integration Ideas**: Documentation for integrating with Claude Code and other AI tools

Bug Fixes
---------
- Fixed signal handler blocking issue in observer base
- Fixed ActiveSupport autoload issues
- Replaced deprecated stub with allow().to receive() in specs

Dependencies
------------
- Replaced watchr with listen and filewatcher observers
- Updated to modern notifiers gem (from GitHub main branch)
- Removed growl dependency

Internal Changes
----------------
- Rewrite of the entire library with separated responsibilities
- Shared examples for creating custom strategies, frameworks, and observers
- Updated all specs to modern RSpec syntax
- Comprehensive test coverage (250+ examples)

v1.0.1
======

- Fix a serious bug for Test::unit users (just run one test file instead of all tests)

v1.0.0
==============

Features
--------

- Added the <b>Fuu</b> images: <a href="https://github.com/tomas-stefano/infinity_test/tree/master/images/fuuu/">https://github.com/tomas-stefano/infinity_test/tree/master/images/fuuu/</a> (thanks to Marcio Giaxia)

- Added the RVM System Wide support (For more information see http://rvm.beginrescueend.com/deployment/system-wide/ )

- Added the Heuristics feature(<b>For users who want to add your own paths</b>)

To see the Heuristics that InfinityTest will see type in ther terminal:

     infinity_test --heuristics

This example tell to InfinityTest <b>run all the tests when some_file.rb is changed</b>
This basic DSL you will put in the <b>infinity_test file</b>:

      heuristics do
        add('some_file.rb') do |file|
          run :all => :tests
        end
      end

If you want run only the similar test file you can do too:

      heuristics do
        add('some_file.rb') do |file|
          run :test_for => file
        end
      end

If you want run only the similar test in some dir, you can do too:

      heuristics do
        add('some_file.rb') do |file|
          run :test_for => file, :in_dir => :models
        end
      end

If you want run all tests in a particular dir, you can do too:

      heuristics do
        add('some_file.rb') do |file|
          run :all => :tests, :in_dir => :controllers
        end
      end

You can pass an array of dirs too (w00t!!):

      heuristics do
        add('some_file.rb') do |file|
          run :all => :tests, :in_dir => [:controllers, :models]
        end
      end

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
If you want run with Bacon just run with --bacon flag or add :test_framework => :bacon to infinity_test file

- Possible to setup the lib pattern, test pattern (thanks to Jason Rogers).

      # ~/.infinity_test or ./.infinity_test
         infinity_test do
          before_env do |application|
             application.test_framework.test_directory_pattern = "^my_unusual_spec_directory/unit/(.*)_spec.rb"
             application.test_framework.test_pattern           = "my_unusual_spec_directory/unit/*_spec.rb"
             application.library_directory_pattern             = '^my_unusual_lib_directory/*/(.*).rb'
           end
         end

OBS.: <b>The #before_env methods is an alias to #replace_patterns method</b>

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
