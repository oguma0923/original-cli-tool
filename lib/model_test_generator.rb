class ModelTestGenerator
  require 'active_support/inflector'
  require 'erb'

  def initialize(model_name)
    @model_name = model_name.underscore.singularize
  end

  def generate
    path_output = File.expand_path("../out/#{@model_name}_spec.rb", __dir__)
    path_template = File.expand_path('../templates/model_spec.rb.erb', __dir__)

    model_test_erb = ERB.new(File.read(path_template), trim_mode: 2)
    File.write(path_output, model_test_erb.result(binding))
  end
end
