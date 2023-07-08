require 'rails_helper'

RSpec.describe CsvConverter, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let(:output_file_path) { Rails.root.join('tmp/test_output.csv') }
  let(:input_file_path) { fixture_file_upload('/input.csv', 'text/csv') }
  let(:empty_file_path) { fixture_file_upload('/empty.csv', 'text/csv') }
  let(:not_csv_file_path) { fixture_file_upload('/not_csv.txt', 'text/txt') }

  describe '#convert' do
    before do
      FactoryBot.create(:feature, user: user)
      service_format = FactoryBot.create(:service_format)
      version = FactoryBot.create(:version, service_format: service_format)

      FactoryBot.create(:mapping, user_column: 'item_number', ec_column: 'handle', data_type: 0, version: version)
      FactoryBot.create(:mapping, user_column: 'item_name', ec_column: 'title', data_type: 0, version: version)
      FactoryBot.create(:mapping, user_column: 'price', ec_column: 'price', data_type: 1, version: version)
    end

    let(:mappings) { Mapping.where(user_column: 'item_number').or(Mapping.where(user_column: 'item_name')).or(Mapping.where(user_column: 'price')) }

    after do
      File.delete(output_file_path) if File.exist?(output_file_path)
    end

    context '正しいinputファイルが渡された時' do
      before do
        converter = CsvConverter.new(input_file_path, mappings)
        converter.convert_csv(output_file_path)
        @output = CSV.read(output_file_path, headers: true)
      end

      it 'ヘッダーが正しくコンバートされる' do
        expect(@output.headers).to eq(['handle', 'title', 'price'])
      end

      it '各行の各値が正しくコンバートされる' do
        expect(@output[0].to_h).to eq({ 'handle' => 'A0001', 'title' => 'sample1', 'price' => '15.00' })
        expect(@output[1].to_h).to eq({ 'handle' => 'B0002', 'title' => 'sample2', 'price' => '23.00' })
        expect(@output[2].to_h).to eq({ 'handle' => 'C0001', 'title' => 'sample3', 'price' => '13.50' })
      end
    end

    context 'inputファイルが空の場合' do
      before do
        converter = CsvConverter.new(empty_file_path, mappings)
        converter.convert_csv(output_file_path)
        @output = CSV.read(output_file_path, headers: true)
      end

      it 'ヘッダーのみのファイルが出力される' do
        expect(@output.headers).to eq(['handle', 'title', 'price'])
        expect(@output.count).to eq(0)
      end
    end
  end

  describe '#validate_input_file' do
    before do
      FactoryBot.create(:feature, user: user)
      service_format = FactoryBot.create(:service_format)
      version = FactoryBot.create(:version, service_format: service_format)

      FactoryBot.create(:mapping, user_column: 'item_number', ec_column: 'handle', data_type: 0, version: version)
      FactoryBot.create(:mapping, user_column: 'item_name', ec_column: 'title', data_type: 0, version: version)
      FactoryBot.create(:mapping, user_column: 'price', ec_column: 'price', data_type: 1, version: version)
    end

    let(:mapping) { Mapping.all }

    context 'inputファイルを指定しなかった場合' do
      let(:converter) { CsvConverter.new(nil, mapping) }

      it 'エラーを発生させる' do
        converter.convert_csv(output_file_path)
        expect(converter.errors).to include('No input file specified')
      end
    end

    context 'inputファイルの拡張子が.csvではない場合' do
      let(:converter) { CsvConverter.new(not_csv_file_path, mapping) }

      it 'Invalid file formatエラーを発生させる' do
        converter.convert_csv(output_file_path)
        expect(converter.errors).to include('Error: Invalid file format')
      end
    end
  end
end
