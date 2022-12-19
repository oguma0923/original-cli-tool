class FactoryBotGenerator
  require 'active_support/inflector'
  require 'erb'

  def initialize(model_name, columns)
    @model_name = model_name.underscore.singularize
    @columns = columns.map do |column|
      column_name, data_type = column.split(':')
      { column_name: column_name, data_type: data_type }
    end
  end

  def generate
    path_output = File.expand_path("../out/#{@model_name.pluralize}.rb", __dir__)
    path_template = File.expand_path('../templates/factory_bot.rb.erb', __dir__)

    test_data = ''
    @columns.each { |column| test_data << test_data_text(column) }

    factory_bot_erb = ERB.new(File.read(path_template), trim_mode: 2)
    File.write(path_output, factory_bot_erb.result(binding))
  end

  private

  def test_data_text(column)
    "    #{column[:column_name]} { #{generate_test_data(column[:data_type])} }\n"
  end

  def generate_test_data(data_type)
    case data_type
    when 'integer'
      1
    when 'string', 'text'
      "'test'"
    when 'float'
      0.1
    when 'date'
      'Date.new(2000, 1, 1)'
    when 'time'
      'Time.new(2000, 1, 1)'
    when 'datetime'
      'DateTime.new(2000, 1, 1)'
    when 'boolean'
      true
    end
  end
end
