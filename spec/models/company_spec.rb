require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { build(:company) }

  describe '.get_record_val_by' do
    context 'retrieving real attributes from associated models' do
      before(:each) do
        allow(described_class)
          .to receive(:find_by_name)
          .with(instance_of(String))
          .and_return(company)
      end

      it 'returns company name' do
        attribute = :name
        value = 'foo'
        return_attr = 'name'
        actual = described_class.get_record_val_by(attribute, value, return_attr)
        expect(actual).to eq 'Example Company'
      end
    end
  end

  describe '#permalink' do
    it 'calls parameterize on the name' do
      allow(company).to receive(:name).and_return('FOO BAR')
      expect(company.name).to receive(:parameterize)
      company.permalink
    end
  end
end
