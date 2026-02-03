# Infinity Test

**To Infinity and Beyond!**

Infinity Test is a continuous testing library and a flexible alternative to Autotest and Guard. It watches your files for changes and automatically runs your tests, providing instant feedback with desktop notifications.

Version 2.0.0 brings a complete rewrite with modern dependencies, multi-Ruby support via RVM/RbEnv, a powerful callbacks system, and experimental support for Elixir (Phoenix, ExUnit), Python (Django, FastAPI, Pytest), and Rust (Rocket, Cargo).

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Command Line Options](#command-line-options)
- [Configuration File (INFINITY_TEST)](#configuration-file-infinity_test)
- [Ruby Version Managers](#ruby-version-managers)
- [Test Frameworks](#test-frameworks)
- [Application Frameworks](#application-frameworks)
- [Experimental: Elixir Support](#experimental-elixir-support)
- [Experimental: Python Support](#experimental-python-support)
- [Experimental: Rust Support](#experimental-rust-support)
- [Notifications](#notifications)
- [Image Themes](#image-themes)
- [Callbacks](#callbacks)
- [File Watching](#file-watching)
- [Advanced Usage](#advanced-usage)

---

## Installation

Since this is a release candidate (rc1), you need to explicitly request the pre-release version:

```bash
gem install infinity_test --pre
```

Or add to your Gemfile:

```ruby
gem 'infinity_test', '~> 2.0.0.rc2', group: :development
```

Then run:

```bash
bundle install
```

---

## Quick Start

### Step 1: Navigate to your project

```bash
cd /path/to/your/project
```

### Step 2: Run Infinity Test

```bash
infinity_test
```

That's it! Infinity Test will:

1. Auto-detect your test framework (RSpec, Test::Unit, ExUnit, or Pytest)
2. Auto-detect your application framework (Rails, Padrino, Rubygems, Phoenix, Django, FastAPI, etc.)
3. Run all tests immediately
4. Watch for file changes and re-run relevant tests
5. Show desktop notifications with test results

### Step 3: Start coding

Edit your files and watch the tests run automatically!

---

## Command Line Options

| Option | Short | Description |
|--------|-------|-------------|
| `--ruby strategy` | | Ruby manager strategy: `auto_discover`, `rvm`, `rbenv`, `ruby_default` |
| `--rubies=versions` | | Ruby versions to test against (comma-separated) |
| `--test library` | | Test framework: `auto_discover`, `rspec`, `test_unit`, `ex_unit`, `pytest`, `cargo_test` |
| `--framework library` | | Application framework: `auto_discover`, `rails`, `padrino`, `rubygems`, `phoenix`, `elixir_mix`, `django`, `fast_api`, `python_package`, `rocket`, `rust_cargo` |
| `--options=options` | | Additional options to pass to test command |
| `--notifications library` | | Notification system: `auto_discover`, `osascript`, `terminal_notifier`, `notify_send`, `dunstify` |
| `--mode theme` | | Image theme for notifications (see [Image Themes](#image-themes)) |
| `--no-infinity-and-beyond` | `-n` | Run tests once and exit (CI mode) |
| `--just-watch` | `-j` | Skip initial test run, only watch for changes |
| `--focus [FILE]` | `-f` | Focus on specific tests or `failures` for last failed tests |
| `--no-verbose` | | Don't print commands before executing |
| `--no-bundler` | | Bypass Bundler support |
| `--help` | | Show help message |

### Examples

**Run with RSpec only:**
```bash
infinity_test --test rspec
```

**Run tests on multiple Ruby versions with RVM:**
```bash
infinity_test --ruby rvm --rubies=3.0.0,3.1.0,3.2.0
```

**Run tests once and exit (for CI):**
```bash
infinity_test -n
```

**Skip initial test run, just watch:**
```bash
infinity_test --just-watch
```

**Focus on failed tests:**
```bash
infinity_test --focus failures
```

**Focus on a specific file:**
```bash
infinity_test --focus spec/models/user_spec.rb
```

**Use a specific notification theme:**
```bash
infinity_test --mode mario_bros
```

**Pass additional options to the test runner:**
```bash
infinity_test --options="-Ilib -Itest"
```

---

## Configuration File (INFINITY_TEST)

You can persist your settings in an `INFINITY_TEST` file. Infinity Test looks for configuration in two locations:

1. **Project file**: `./INFINITY_TEST` (higher priority)
2. **Global file**: `~/INFINITY_TEST` (lower priority)

### Basic Configuration

```ruby
InfinityTest.setup do |config|
  config.test_framework = :rspec
  config.framework      = :rails
  config.notifications  = :terminal_notifier
  config.mode           = :mario_bros
  config.verbose        = true
end
```

### All Configuration Options

```ruby
InfinityTest.setup do |config|
  # Ruby Version Manager
  # Options: :auto_discover, :rvm, :rbenv, :ruby_default
  config.strategy = :auto_discover

  # Ruby versions to test against (requires RVM or RbEnv)
  config.rubies = ['3.0.0', '3.1.0', '3.2.0']

  # Gemset to use with RVM
  config.gemset = 'my_project'

  # Test framework
  # Options: :auto_discover, :rspec, :test_unit, :ex_unit, :pytest, :cargo_test
  config.test_framework = :rspec

  # Application framework
  # Options: :auto_discover, :rails, :padrino, :rubygems, :phoenix, :elixir_mix, :django, :fast_api, :python_package, :rocket, :rust_cargo
  config.framework = :rails

  # File observer
  # Options: :listen (event-driven), :filewatcher (polling)
  config.observer = :listen

  # Notification system
  # Options: :auto_discover, :osascript, :terminal_notifier, :notify_send, :dunstify
  config.notifications = :auto_discover

  # Image theme for notifications
  config.mode = :simpson

  # Or use custom images
  config.success_image = '/path/to/success.png'
  config.failure_image = '/path/to/failure.png'
  config.pending_image = '/path/to/pending.png'

  # Bundler support (auto-detected if Gemfile exists)
  config.bundler = true

  # Print commands before executing
  config.verbose = true

  # File extension to watch
  config.extension = :rb

  # Skip initial test run
  config.just_watch = false

  # Run tests and exit (CI mode)
  config.infinity_and_beyond = true

  # Focus mode: nil, :failures, or file path
  config.focus = nil

  # Ignore specific test files
  config.ignore_test_files = [
    'spec/slow/performance_spec.rb'
  ]

  # Ignore test folders
  config.ignore_test_folders = [
    'spec/integration'
  ]
end
```

### Configuration with Callbacks

```ruby
InfinityTest.setup do |config|
  config.test_framework = :rspec
  config.mode           = :faces
end

# Clear terminal before running tests
InfinityTest::Core::Base.before(:all) do
  InfinityTest::Core::Base.clear_terminal
end

# Run after all tests complete
InfinityTest::Core::Base.after(:all) do
  system('say "Tests finished"')
end

# Run before each Ruby version (when testing multiple rubies)
InfinityTest::Core::Base.before(:each_ruby) do |environment|
  puts "Testing with Ruby #{environment[:ruby_version]}"
end

# Run after each Ruby version
InfinityTest::Core::Base.after(:each_ruby) do |environment|
  puts "Finished testing Ruby #{environment[:ruby_version]}"
end
```

---

## Ruby Version Managers

Infinity Test supports testing across multiple Ruby versions using RVM or RbEnv.

### Auto Discovery (Default)

```ruby
config.strategy = :auto_discover
```

Priority order: RVM > RbEnv > RubyDefault

### RVM Strategy

Test against multiple Ruby versions with optional gemset support:

```ruby
InfinityTest.setup do |config|
  config.strategy = :rvm
  config.rubies   = ['3.0.0', '3.1.0', 'jruby-9.4.0.0']
  config.gemset   = 'infinity_test'  # Optional
end
```

**Command line:**
```bash
infinity_test --ruby rvm --rubies=3.0.0,3.1.0,jruby-9.4.0.0
```

### RbEnv Strategy

Test against multiple Ruby versions using rbenv:

```ruby
InfinityTest.setup do |config|
  config.strategy = :rbenv
  config.rubies   = ['3.0.0', '3.1.0', '3.2.0']
end
```

**Command line:**
```bash
infinity_test --ruby rbenv --rubies=3.0.0,3.1.0
```

### Ruby Default Strategy

Use the current Ruby version only (no version manager):

```ruby
config.strategy = :ruby_default
```

---

## Test Frameworks

### RSpec

Auto-detected when `spec/` directory exists with `spec_helper.rb` or `*_spec.rb` files.

```ruby
config.test_framework = :rspec
```

### Test::Unit / Minitest

Auto-detected when `test/` directory exists with `test_helper.rb` or `*_test.rb` files.

```ruby
config.test_framework = :test_unit
```

### Other Test Frameworks (Experimental)

See [Elixir Support](#experimental-elixir-support) for ExUnit and [Python Support](#experimental-python-support) for Pytest.

---

## Application Frameworks

### Rails

Auto-detected when `config/environment.rb` exists.

**Watched directories:**
- `app/models` → runs corresponding model specs/tests
- `app/controllers` → runs corresponding controller specs/tests
- `app/helpers` → runs corresponding helper specs/tests
- `app/mailers` → runs corresponding mailer specs/tests
- `app/jobs` → runs corresponding job specs/tests
- `lib/` → runs corresponding lib specs/tests
- `spec/` or `test/` → runs the changed spec/test file
- `spec_helper.rb` or `test_helper.rb` → runs all tests

### Padrino

Auto-detected when `config/boot.rb` exists with Padrino reference.

Similar heuristics to Rails with Padrino-specific paths.

### Rubygems (Default)

Used for gem development and simple Ruby projects.

**Watched directories:**
- `lib/` → runs corresponding specs/tests
- `spec/` or `test/` → runs the changed spec/test file

---

## Experimental: Elixir Support

> **Note:** Elixir support is experimental. Please report any issues.

Infinity Test can watch Elixir projects and run ExUnit tests automatically.

### ExUnit Test Framework

Auto-detected when `test/` directory exists with `test_helper.exs` or `*_test.exs` files.

```ruby
config.test_framework = :ex_unit
```

### Phoenix Framework

Auto-detected when `mix.exs` exists and `lib/*_web/` directory is present.

**Watched directories:**
- `lib/my_app/` → runs corresponding tests in `test/my_app/`
- `lib/my_app_web/controllers/` → runs corresponding controller tests
- `lib/my_app_web/live/` → runs corresponding LiveView tests
- `test/` → runs the changed test file
- `test/test_helper.exs` → runs all tests

```ruby
config.framework = :phoenix
```

### ElixirMix Framework

For standard Elixir/Mix projects (non-Phoenix). Auto-detected when `mix.exs` exists.

**Watched directories:**
- `lib/` → runs corresponding tests
- `test/` → runs the changed test file

```ruby
config.framework = :elixir_mix
```

### Elixir Configuration Example

```ruby
InfinityTest.setup do |config|
  config.test_framework = :ex_unit
  config.framework      = :phoenix  # or :elixir_mix
  config.strategy       = :elixir_default
  config.notifications  = :terminal_notifier
end
```

---

## Experimental: Python Support

> **Note:** Python support is experimental. Please report any issues.

Infinity Test can watch Python projects and run Pytest tests automatically.

### Pytest Test Framework

Auto-detected when `tests/` or `test/` directory exists with `test_*.py` or `*_test.py` files.

```ruby
config.test_framework = :pytest
```

**Output parsing:**
- `5 passed` → success
- `1 failed, 4 passed` → failure
- `4 passed, 1 skipped` → pending

### Django Framework

Auto-detected when `manage.py` exists with Django imports.

**Watched directories:**
- Django app directories (containing `models.py`, `views.py`, or `apps.py`)
- Each app's `tests/` directory or `tests.py` file
- `conftest.py` → runs all tests

```ruby
config.framework = :django
```

### FastAPI Framework

Auto-detected when `main.py` (or `app/main.py`, `src/main.py`) contains FastAPI imports. Ideal for ML model serving APIs.

**Watched directories:**
- `app/` → API application code
- `routers/` → API route definitions
- `api/` → API endpoints
- `endpoints/` → endpoint handlers
- `tests/` → test files

```ruby
config.framework = :fast_api
```

### PythonPackage Framework

For standard Python packages. Auto-detected when `pyproject.toml`, `setup.py`, or `setup.cfg` exists.

**Watched directories:**
- `src/` → source code
- `lib/` → library code
- Package directories (containing `__init__.py`)
- `tests/` or `test/` → test files

```ruby
config.framework = :python_package
```

### Python Configuration Example

```ruby
InfinityTest.setup do |config|
  config.test_framework = :pytest
  config.framework      = :fast_api  # or :django, :python_package
  config.strategy       = :python_default
  config.notifications  = :terminal_notifier
end
```

### Python Project Structure Examples

**FastAPI ML API:**
```
my_ml_api/
├── app/
│   ├── main.py          # from fastapi import FastAPI
│   ├── models/          # ML models
│   └── routers/         # API endpoints
├── tests/
│   ├── conftest.py
│   └── test_api.py
└── pyproject.toml
```

**Django ML Dashboard:**
```
my_dashboard/
├── manage.py
├── dashboard/           # Django app
│   ├── models.py
│   ├── views.py
│   └── tests/
├── ml_pipeline/         # Django app
│   ├── models.py
│   └── tests.py
└── requirements.txt
```

---

## Experimental: Rust Support

> **Note:** Rust support is experimental. Please report any issues.

Infinity Test can watch Rust projects and run `cargo test` automatically.

### CargoTest Test Framework

Auto-detected when `Cargo.toml` exists.

```ruby
config.test_framework = :cargo_test
```

**Output parsing:**
- `5 passed; 0 failed; 0 ignored` → success
- `3 passed; 2 failed; 0 ignored` → failure
- `4 passed; 0 failed; 1 ignored` → pending

### Rocket Framework

Auto-detected when `Cargo.toml` contains `rocket` dependency. For Rocket web applications.

**Watched directories:**
- `src/*.rs` → runs tests matching the module name (e.g., `src/routes.rs` → `cargo test routes`)
- `src/lib.rs` or `src/main.rs` → runs all tests
- `tests/*.rs` → runs the specific integration test
- `Cargo.toml` → runs all tests
- `Rocket.toml` → runs all tests (if exists)

```ruby
config.framework = :rocket
```

### RustCargo Framework

For standard Rust libraries and applications. Auto-detected when `Cargo.toml` exists (and no Rocket dependency).

**Watched directories:**
- `src/*.rs` → runs tests matching the module name
- `tests/*.rs` → runs the specific integration test
- `Cargo.toml` → runs all tests

```ruby
config.framework = :rust_cargo
```

### Rust Configuration Example

```ruby
InfinityTest.setup do |config|
  config.test_framework = :cargo_test
  config.framework      = :rust_cargo  # or :rocket
  config.strategy       = :rust_default
  config.notifications  = :terminal_notifier
end
```

### Rust Project Structure Example

```
my_rust_project/
├── Cargo.toml
├── src/
│   ├── lib.rs           # Changes run all tests
│   ├── user.rs          # Changes run `cargo test user`
│   └── utils.rs         # Changes run `cargo test utils`
└── tests/
    ├── integration.rs   # Changes run `cargo test --test integration`
    └── api_tests.rs     # Changes run `cargo test --test api_tests`
```

---

## Notifications

Desktop notifications show test results with themed images.

### Notification Systems

| System | Platform | Description |
|--------|----------|-------------|
| `auto_discover` | All | Automatically detect available notifier |
| `terminal_notifier` | macOS | Modern macOS notifications |
| `osascript` | macOS | Built-in AppleScript notifications |
| `notify_send` | Linux | libnotify notifications |
| `dunstify` | Linux | Dunst notification daemon |

**Configuration:**
```ruby
config.notifications = :terminal_notifier
```

**Command line:**
```bash
infinity_test --notifications terminal_notifier
```

---

## Image Themes

Infinity Test includes fun image themes for notifications. Each theme has three images: `success`, `failure`, and `pending`.

### Available Themes

| Theme | Description | Location |
|-------|-------------|----------|
| `simpson` | The Simpsons characters (default) | `images/simpson/` |
| `faces` | Expressive face icons | `images/faces/` |
| `fuuu` | Rage comic faces | `images/fuuu/` |
| `hands` | Hand gesture icons | `images/hands/` |
| `mario_bros` | Super Mario characters | `images/mario_bros/` |
| `rails` | Ruby on Rails themed | `images/rails/` |
| `rubies` | Ruby gemstone themed | `images/rubies/` |
| `street_fighter` | Street Fighter characters | `images/street_fighter/` |
| `toy_story` | Toy Story characters | `images/toy_story/` |

### Using a Theme

**Configuration file:**
```ruby
config.mode = :mario_bros
```

**Command line:**
```bash
infinity_test --mode mario_bros
```

### Custom Images

Use your own images by setting the image paths directly:

```ruby
InfinityTest.setup do |config|
  config.success_image = '/path/to/my_success.png'
  config.failure_image = '/path/to/my_failure.png'
  config.pending_image = '/path/to/my_pending.png'
end
```

Or point to a custom directory containing `success.*`, `failure.*`, and `pending.*` images:

```ruby
config.mode = '/path/to/my/images/directory'
```

---

## Callbacks

Callbacks let you run custom code before or after tests.

### Available Callbacks

| Callback | Scope | Description |
|----------|-------|-------------|
| `before(:all)` | All | Runs once before all tests |
| `after(:all)` | All | Runs once after all tests |
| `before(:each_ruby)` | Per Ruby | Runs before testing each Ruby version |
| `after(:each_ruby)` | Per Ruby | Runs after testing each Ruby version |

### Examples

**Clear terminal before tests:**
```ruby
InfinityTest::Core::Base.before(:all) do
  InfinityTest::Core::Base.clear_terminal
end
```

**Play a sound after tests:**
```ruby
InfinityTest::Core::Base.after(:all) do
  system('afplay /path/to/sound.mp3')
end
```

**Log Ruby version being tested:**
```ruby
InfinityTest::Core::Base.before(:each_ruby) do |env|
  File.write('test.log', "Testing: #{env[:ruby_version]}\n", mode: 'a')
end
```

**Compile extensions before each Ruby:**
```ruby
InfinityTest::Core::Base.before(:each_ruby) do |env|
  system('rake compile')
end
```

---

## File Watching

### Listen (Default)

Event-driven file watching using native OS notifications. Fast and efficient.

```ruby
config.observer = :listen
```

### Filewatcher

Polling-based file watching. Works everywhere including VMs and NFS mounts.

```ruby
config.observer = :filewatcher
```

---

## Advanced Usage

### Continuous Integration Mode

Run tests once and exit with proper exit code:

```bash
infinity_test -n
```

Or in configuration:
```ruby
config.infinity_and_beyond = false
```

### Just Watch Mode

Skip the initial test run and only watch for changes. Useful for large projects:

```bash
infinity_test --just-watch
```

### Focus Mode

Run only specific tests:

```bash
# Run only previously failed tests
infinity_test --focus failures

# Run only a specific file
infinity_test --focus spec/models/user_spec.rb
```

### Ignoring Files

```ruby
InfinityTest.setup do |config|
  # Ignore specific test files
  config.ignore_test_files = [
    'spec/slow/large_integration_spec.rb',
    'spec/external/api_spec.rb'
  ]

  # Ignore entire directories
  config.ignore_test_folders = [
    'spec/integration',
    'spec/system'
  ]
end
```

### Watching Non-Ruby Files

```ruby
# Watch Python files
config.extension = :py

# Watch JavaScript files
config.extension = :js
```

### Sample Complete Configuration

```ruby
# INFINITY_TEST

InfinityTest.setup do |config|
  # Multi-Ruby testing with RVM
  config.strategy = :rvm
  config.rubies   = ['3.1.0', '3.2.0', '3.3.0']
  config.gemset   = 'myapp'

  # Test framework and app framework
  config.test_framework = :rspec
  config.framework      = :rails

  # Notifications with Mario theme
  config.notifications = :terminal_notifier
  config.mode          = :mario_bros

  # Performance settings
  config.observer   = :listen
  config.just_watch = false
  config.verbose    = true

  # Ignore slow tests during development
  config.ignore_test_folders = ['spec/system']
end

# Clear screen before each run
InfinityTest::Core::Base.before(:all) do
  InfinityTest::Core::Base.clear_terminal
end

# Notify via system sound when done
InfinityTest::Core::Base.after(:all) do
  system('afplay /System/Library/Sounds/Glass.aiff')
end
```

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run the tests (`infinity_test`)
4. Commit your changes (`git commit -am 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Create a Pull Request

---

## License

MIT License - see [LICENSE.txt](LICENSE.txt) for details.

---

## Author

Tomas D'Stefano

**Happy Testing!**
