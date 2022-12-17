class RailsTestGenerator
  require 'optparse'
  require "#{__dir__}/request_test_generator"
  require "#{__dir__}/model_test_generator"
  # require "#{__dir__}/factory_bot_generator"

  def initialize(argv)
    @excluded_actions = []

    OptionParser.new do |options|
      options.on(
        '-r',
        '--request controller_name',
        '指定したコントローラ名のリクエストテストを生成 例：-r test'
      ) do |controller_name|
        @controller_name = controller_name
      end

      options.on(
        '-e',
        '--exclude actions',
        Array,
        'リクエストテストから除外するアクションを指定(カンマ区切り) 例：-e index,show'
      ) do |excluded_actions|
        @excluded_actions = excluded_actions
      end

      options.on(
        '-m',
        '--model model_name',
        '指定した名前のモデルテストを生成 例：-m test'
      ) do |model_name|
        @model_name = model_name
      end

      options.on(
        '-c',
        '--columns column_name:type',
        Array,
        'FactoryBotで定義するカラム名と型を指定 例：-c title:strings,birthday:date'
      ) do |columns|
        @columns = columns
      end

      options.parse(argv)
    end
  end

  def generate
    RequestTestGenerator.new(@controller_name, @excluded_actions).generate if @controller_name
    ModelTestGenerator.new(@model_name).generate if @model_name
    FactoryBotGenerator.new(@columns).generate if @columns
  end
end

RailsTestGenerator.new(ARGV).generate if __FILE__ == $PROGRAM_NAME
