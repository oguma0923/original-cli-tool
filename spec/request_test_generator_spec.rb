require_relative '../request_test_generator'

RSpec.describe RequestTestGenerator do
  let(:controller_name) { 'test' }
  let(:generated_file) { 'out/tests_spec.rb' }

  describe 'generate' do
    after { File.delete(generated_file) }

    context 'controller_name' do
      it 'controller_nameに対応したテストファイルが生成されること' do
        RequestTestGenerator.new(controller_name, []).generate
        expect(File).to exist(generated_file)
      end
    end

    context 'excluded_actions' do
      it '指定したアクションに関するテストを除外できること' do
        RequestTestGenerator.new(controller_name, ['index']).generate
        expect(File.read(generated_file)).not_to include("describe 'GET /tests' do")
      end

      it 'アクションを指定しなければすべてのアクションに関するテストが生成されること' do
        RequestTestGenerator.new(controller_name, []).generate
        expect(File.read(generated_file)).to include("describe 'GET /tests' do")
        expect(File.read(generated_file)).to include("describe 'GET /tests/:id' do")
        expect(File.read(generated_file)).to include("describe 'GET /tests/new' do")
        expect(File.read(generated_file)).to include("describe 'GET /tests/:id/edit' do")
        expect(File.read(generated_file)).to include("describe 'POST /tests' do")
        expect(File.read(generated_file)).to include("describe 'PATCH/PUT /tests/:id' do")
        expect(File.read(generated_file)).to include("describe 'DELETE /tests/:id' do")
      end
    end
  end
end
