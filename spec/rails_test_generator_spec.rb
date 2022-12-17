require_relative '../rails_test_generator'

RSpec.describe RailsTestGenerator do
  let(:controller_name) { 'test' }
  let(:request_test_file) { 'out/tests_spec.rb' }
  let(:model_name) { 'test' }
  let(:model_test_file) { 'out/test.rb' }

  describe 'generate --request' do
    after { File.delete(request_test_file) }

    context '除外するアクションを指定しないとき' do
      it 'controller_nameに対応したリクエストテストが生成される' do
        RailsTestGenerator.new(['--request', controller_name]).generate
        expect(File).to exist(request_test_file)
      end

      it 'すべてのアクションに関するテストが生成されること' do
        RailsTestGenerator.new(['--request', controller_name]).generate
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
      it 'controller_nameに対応したリクエストテストが生成されること' do
        RailsTestGenerator.new(['--request', controller_name, '--exclude', 'index,show']).generate
        expect(File).to exist(request_test_file)
      end

      it '指定したアクションが除外されること' do
        RailsTestGenerator.new(['--request', controller_name, '--exclude', 'index,show']).generate
        expect(File.read(request_test_file)).not_to include("describe 'GET /tests' do")
        expect(File.read(request_test_file)).not_to include("describe 'GET /tests/:id' do")
      end
    end
  end

  describe 'generate --model' do
    it 'model_nameに対応したモデルテストが作成されること' do
      RailsTestGenerator.new(['--model', model_name])
      expect(File).to exist(model_test_file)
    end
  end
end
