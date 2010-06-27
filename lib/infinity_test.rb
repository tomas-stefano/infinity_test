module InfinityTest
  autoload :Application, 'infinity_test/application'
  autoload :BinaryPath, 'infinity_test/binary_path'
  autoload :CommandLine, 'infinity_test/command_line'
  autoload :Cucumber, 'infinity_test/cucumber'
  autoload :Rspec, 'infinity_test/rspec'
  autoload :TestUnit, 'infinity_test/test_unit'

  def self.application
    @application ||= Application.new
  end
  
  def self.start!
    CommandLine.start
  end

end