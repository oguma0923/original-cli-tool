class ModelTestGenerator
  require 'active_support/inflector'
  require 'erb'

  def initialize(model_name)
    @model_name = model_name.underscore.singularize
  end

  def generate
    path_output = "#{__dir__}/out/#{@model_name}.rb"
    path_template = "#{__dir__}/lib/model_spec.rb.erb"

    model_test_erb = ERB.new(File.read(path_template), trim_mode: 2)
    File.write(path_output, model_test_erb.result(binding))
  end
end
