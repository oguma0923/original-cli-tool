require 'active_support/inflector'
require 'erb'

class RequestTestGenerator
  def initialize(controller_name)
    @controller_name = controller_name.underscore.singularize
  end

  def generate
    path_output = File.join(__dir__, 'out', "#{@controller_name.pluralize}_spec.rb")
    path_template = File.join(__dir__, 'lib', 'request_spec.rb.erb')

    request_test_erb = ERB.new(File.read(path_template))
    File.write(path_output, request_test_erb.result(binding))
  end
end

RequestTestGenerator.new('test').generate if __FILE__ == $PROGRAM_NAME
