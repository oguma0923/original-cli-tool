require_relative '../lib/factory_bot_generator'

RSpec.describe FactoryBotGenerator do
  let(:model_name) { 'test' }
  let(:columns) { ['int:integer', 'str:string'] }
  let(:factory_bot_file) { File.expand_path('../out/tests.rb', __dir__) }

  describe 'generate' do
    after { File.delete(factory_bot_file) }

    it 'model_nameに対応したFactoryBotファイルが作成されること' do
      FactoryBotGenerator.new(model_name, columns).generate
      expect(File).to exist(factory_bot_file)
    end
  end
end
