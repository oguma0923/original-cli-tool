class RailsTestGenerator
  require 'optparse'
  require "#{__dir__}/lib/request_test_generator"
  require "#{__dir__}/lib/model_test_generator"
  require "#{__dir__}/lib/factory_bot_generator"

  def initialize(argv)
    @modes = []
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
      ) { @modes << :request }

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
      ) { @modes << :model }

      options.on(
        '-f',
        '--factory_bot column_name:data_type',
        Array,
        'FactoryBotで定義するカラム名と型を指定 例：-f title:strings,birthday:date'
      ) do |columns|
        @columns = columns
        @modes << :factory_bot
      end

      options.parse(argv)
    end
  end

  def generate
    raise ArgumentError, '--nameによるモデル名（コントローラ名）の指定がありません。' if @name.nil?
    raise ArgumentError, '--request, --model, --columnsのうち1つ以上の指定が必須です。' if @modes.empty?

    @modes.each do |mode|
      case mode
      when :request
        RequestTestGenerator.new(@name, @excluded_actions).generate
      when :model
        ModelTestGenerator.new(@name).generate
      when :factory_bot
        FactoryBotGenerator.new(@name, @columns).generate
      end
    end
  end
end

RailsTestGenerator.new(ARGV).generate if __FILE__ == $PROGRAM_NAME
