module InfinityTest
  module Strategy
    class Rvm < Base
      def run!
        base.rubies.each do |ruby_version|
          command.rvm.do.ruby_version.ruby.add('-S').add(test_framework.binary).add(test_framework.test_dir)
        end
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