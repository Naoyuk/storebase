require 'rails_helper'

RSpec.describe Version, type: :model do
  describe '#save_with_mappings' do
    let!(:service) { FactoryBot.create(:service) }
    let!(:service_format) { FactoryBot.create(:service_format, service: service) }
    let!(:feature) { FactoryBot.create(:feature, service: service) }

    before do
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
    end

    context "when a version and all related mappings are valid" do
      it 'creates mappings related with the version' do
        version = feature.versions.build(current: true, service_format: service_format)

        expect {
          version.save_with_mappings
        }.to change(Mapping, :count).by(5).and change(Version, :count).by(1)
      end
    end

    context "when a version is invalid" do
      it "doesn't create a version nor mappings related with the version" do
        version = feature.versions.build(current: nil, service_format: service_format)

        expect {
          version.save_with_mappings
        }.to change(Mapping, :count).by(0).and change(Version, :count).by(0)
      end
    end
  end
end
