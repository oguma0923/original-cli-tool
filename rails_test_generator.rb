class RailsTestGenerator
  require 'optparse'
  require "#{__dir__}/request_test_generator"
  require "#{__dir__}/model_test_generator"
  require "#{__dir__}/factory_bot_generator"

  def initialize(argv)
    @excluded_actions = []

    OptionParser.new do |options|
      options.on(
        '-n',
        '--name name',
        String,
        '*** 必須 *** テスト対象のモデル名（コントローラ名）を指定 例: -n test'
      ) do |name|
        @name = name
      end

      options.on(
        '-r',
        '--request',
        'リクエストテストを生成 例：-r'
      ) { @request = true }

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
        '--model',
        'モデルテストを生成 例：-m'
      ) { @model = true }

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
    raise ArgumentError, '--nameによるモデル名（コントローラ名）の指定がありません。' if @name.nil?

    RequestTestGenerator.new(@name, @excluded_actions).generate if @request
    ModelTestGenerator.new(@name).generate if @model
    FactoryBotGenerator.new(@name, @columns).generate if @columns
  end
end

RailsTestGenerator.new(ARGV).generate if __FILE__ == $PROGRAM_NAME
