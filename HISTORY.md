# History

## 2.0.0

### New Features

- **Elixir Support**: Added ExUnit test framework, ElixirMix and Phoenix frameworks, and ElixirDefault strategy
  - Auto-discovers Elixir projects by detecting `mix.exs`
  - Phoenix framework: detects `lib/*_web` directory, watches all lib subdirectories
  - ElixirMix framework: for standard Mix projects
  - Watches `lib/**/*.ex` and `test/**/*.exs` files
  - Parses ExUnit output (tests, failures, skipped)

- **Python Support**: Added Pytest test framework, PythonPackage framework, and PythonDefault strategy
  - Auto-discovers Python projects by detecting `pyproject.toml`, `setup.py`, or `setup.cfg`
  - Watches `src/`, `lib/`, and package directories with `__init__.py`
  - Watches `tests/` or `test/` directories for test files
  - Parses Pytest output (passed, failed, skipped)

- **Django Framework**: Full support for Django projects
  - Auto-discovers Django projects by detecting `manage.py` with Django imports
  - Watches Django app directories (models.py, views.py, apps.py)
  - Maps app files to their corresponding tests

- **FastAPI Framework**: Support for FastAPI/ML API projects
  - Auto-discovers FastAPI projects by detecting FastAPI imports in main.py
  - Watches `app/`, `src/`, `routers/`, `api/`, `endpoints/` directories
  - Perfect for ML model serving APIs

- **Modern Observers**: Replaced watchr with listen and filewatcher observers
  - `listen` (default): Event-driven, uses native OS notifications
  - `filewatcher`: Polling-based, works in VMs/NFS environments

- **RVM and RbEnv Strategies**: Multi-version Ruby testing support
  - Run tests against multiple Ruby versions simultaneously
  - Gemset support for RVM

- **Callbacks System**: Before/after hooks for test runs
  - `before(:all)`, `after(:all)` for all test runs
  - `before(:each_ruby)`, `after(:each_ruby)` for each Ruby version

- **Focus Mode**: Run specific tests with `--focus` option
  - `--focus=:failures` to run only previously failed tests
  - `--focus=path/to/file` to run specific test file

- **Just Watch Mode**: `--just-watch` option to skip initial test run

- **Auto-discover App Directories**: Automatically detect and watch Rails/Padrino app subdirectories (models, controllers, components, etc.)

- **Start Banner**: Display configuration summary on startup

- **Bundler Support**: Automatic `bundle exec` wrapping when Gemfile is present

- **Colored Output**: Preserve terminal colors with PTY and verbose command display

- **CLI Options**: Added `--notifications` and `--mode` options for desktop notifications

### Improvements

- **Modern Notifications**: Updated to use modern notifiers gem with support for:
  - macOS: terminal-notifier, osascript
  - Linux: notify-send, dunstify

- **Priority Ordering**: Auto-discover now respects priority order for strategies, frameworks, and test frameworks

- **Rails and Padrino Heuristics**: Improved file watching patterns for Rails and Padrino applications

- **GitHub Actions**: Replaced Travis CI with GitHub Actions for CI/CD

- **Configuration File**: Renamed config file to `INFINITY_TEST`

### Compatibility

- Updated for Ruby 3.x compatibility
- Updated for ActiveSupport 7.0+ compatibility
- Updated for modern RSpec syntax (replaced deprecated `stub` with `allow().to receive()`)
- Improved test descriptions by removing 'should' prefix
