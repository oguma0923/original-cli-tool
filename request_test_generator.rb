class RequestTestGenerator
  require 'active_support/inflector'
  require 'erb'

  def initialize(controller_name, excluded_actions)
    @controller_name = controller_name.underscore.singularize
    @actions = %w[index show new edit create update destroy] - excluded_actions
  end

  def generate
    path_output = "#{__dir__}/out/#{@controller_name.pluralize}_spec.rb"
    path_template = "#{__dir__}/lib/request_spec.rb.erb"

    request_test_erb = ERB.new(File.read(path_template), trim_mode: 2)
    File.write(path_output, request_test_erb.result(binding))
  end
end
