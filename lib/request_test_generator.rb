class RequestTestGenerator
  require 'active_support/inflector'
  require 'erb'

  def initialize(controller_name, excluded_actions)
    @controller_name = controller_name.underscore.singularize
    @actions = %w[index show new edit create update destroy] - excluded_actions
  end

  def generate
    path_output = File.expand_path("../out/#{@controller_name.pluralize}_spec.rb", __dir__)
    path_template = File.expand_path('../templates/request_spec.rb.erb', __dir__)

    request_test_erb = ERB.new(File.read(path_template), trim_mode: 2)
    File.write(path_output, request_test_erb.result(binding))
  end
end
