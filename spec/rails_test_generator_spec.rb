require_relative '../rails_test_generator'

RSpec.describe RailsTestGenerator do
  let(:name) { 'test' }
  let(:request_test_file) { 'out/tests_spec.rb' }
  let(:model_test_file) { 'out/test_spec.rb' }
  let(:factory_bot_file) { 'out/tests.rb' }

  describe 'generate --name' do
    context '--nameが指定されない場合' do
      it 'ArgumentErrorが発生する' do
        expect { RailsTestGenerator.new(['--request']).generate }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'generate --request' do
    after { File.delete(request_test_file) }

    context '除外するアクションを指定しないとき' do
      it 'nameに対応したリクエストテストが生成される' do
        RailsTestGenerator.new(['--request', '--name', name]).generate
        expect(File).to exist(request_test_file)
      end

      it 'すべてのアクションに関するテストが生成されること' do
        RailsTestGenerator.new(['--request', '--name', name]).generate
        expect(File.read(request_test_file)).to include("describe 'GET /tests' do")
        expect(File.read(request_test_file)).to include("describe 'GET /tests/:id' do")
        expect(File.read(request_test_file)).to include("describe 'GET /tests/new' do")
        expect(File.read(request_test_file)).to include("describe 'GET /tests/:id/edit' do")
        expect(File.read(request_test_file)).to include("describe 'POST /tests' do")
        expect(File.read(request_test_file)).to include("describe 'PATCH/PUT /tests/:id' do")
        expect(File.read(request_test_file)).to include("describe 'DELETE /tests/:id' do")
      end
    end

    context '除外するアクションを指定したとき' do
      it 'nameに対応したリクエストテストが生成されること' do
        RailsTestGenerator.new(['--request', '--name', name, '--exclude', 'index,show']).generate
        expect(File).to exist(request_test_file)
      end

      it '指定したアクションが除外されること' do
        RailsTestGenerator.new(['--request', '--name', name, '--exclude', 'index,show']).generate
        expect(File.read(request_test_file)).not_to include("describe 'GET /tests' do")
        expect(File.read(request_test_file)).not_to include("describe 'GET /tests/:id' do")
      end
    end
  end

  describe 'generate --model' do
    after { File.delete(model_test_file) }

    it 'nameに対応したモデルテストが作成されること' do
      RailsTestGenerator.new(['--model', '--name', name]).generate
      expect(File).to exist(model_test_file)
    end
  end

  describe 'generate --factory_bot' do
    after { File.delete(factory_bot_file) }

    it 'nameに対応したFactoryBotファイルが生成されること' do
      RailsTestGenerator.new(['--factory_bot', 'str:string,int:integer', '--name', name]).generate
      expect(File).to exist(factory_bot_file)
    end
  end
end
