require_relative '../model_test_generator'

RSpec.describe ModelTestGenerator do
  let(:model_name) { 'test' }
  let(:model_test_file) { 'out/test.rb' }

  describe 'generate' do
    after { File.delete(model_test_file) }

    it 'model_nameに対応したモデルテストが作成されること' do
      ModelTestGenerator.new(model_name).generate
      expect(File).to exist(model_test_file)
    end
  end
end
