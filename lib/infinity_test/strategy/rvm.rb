module InfinityTest
  module Strategy
    class Rvm < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      # Build and run commands for each ruby version specified.
      # Uses RVM's `rvm <version> do` syntax to run tests in different Ruby environments.
      #
      # ==== Returns
      #  String: The command string for the first ruby version (others run sequentially)
      #
      def run!
        rubies = Core::Base.rubies
        gemset = Core::Base.gemset

        commands = rubies.map do |ruby_version|
          ruby_with_gemset = gemset.present? ? "#{ruby_version}@#{gemset}" : ruby_version
          command_builder.rvm.add(ruby_with_gemset).do.ruby.option(:S).add(binary).add(test_files).to_s
        end

        commands.join(' && ')
      end

      # ==== Returns
      #  TrueClass: If the user had the rvm installed.
      #  FalseClass: If the user don't had the rvm installed.
      #
      def self.run?
        installed_users_home? or installed_system_wide?
      end

      # ==== Returns
      #  TrueClass: Find rvm installed in ~/.rvm.
      #  FalseClass: Don't Find rvm installed in ~/.rvm.
      #
      def self.installed_users_home?
        File.exist?(File.expand_path('~/.rvm'))
      end

      # ==== Returns
      #  TrueClass: Find rvm installed in /usr/local/rvm.
      #  FalseClass: Don't Find rvm installed in /usr/local/rvm.
      #
      def self.installed_system_wide?
        File.exist?(File.expand_path("/usr/local/rvm"))
      end
    end
  end
end