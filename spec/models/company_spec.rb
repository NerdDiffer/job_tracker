require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { build(:company) }

  describe '.get_record_val_by' do
    context 'retrieving real attributes from associated models' do
      let(:attribute) { :name }
      let(:value)     { 'foo' }
      let(:return_attr) { 'name' }
      let(:result)    { company }

      before(:each) do
        allow(described_class)
          .to receive(:find_by_name)
          .with(value)
          .and_return(company)
        allow(described_class).to receive(:check_result).and_return(company)
        allow(company).to receive(:read_attribute).and_return('Example Company')
      end

      it 'returns company name' do
        actual = described_class.get_record_val_by(attribute, value, return_attr)

        expect(actual).to eq 'Example Company'
      end

      describe 'expected method calls' do
        before(:each) do
          allow(result).to receive(:nil?).and_return(false)
        end
        after(:each) do
          described_class.get_record_val_by(attribute, value, return_attr)
        end

        it 'calls .find_by_name on the class' do
          expect(described_class).to receive(:find_by_name).with(value)
        end
        it 'calls .nil? on result' do
          expect(result).to receive(:nil?)
        end
        it 'calls .check_result' do
          expect(described_class).to receive(:check_result).with(result)
        end
        it 'calls .read_attribute' do
          expect(company).to receive(:read_attribute).with(return_attr)
        end
      end

      context 'when result is nil' do
        before(:each) do
          allow(result).to receive(:nil?).and_return(true)
        end

        it 'returns nil' do
          actual = described_class.get_record_val_by(attribute, value, return_attr)

          expect(actual).to be_nil
        end
        it 'does NOT call check_result' do
          described_class.get_record_val_by(attribute, value, return_attr)

          expect(described_class).not_to receive(:check_result)
        end
        it 'does NOT call read_attribute' do
          described_class.get_record_val_by(attribute, value, return_attr)

          expect(company).not_to receive(:read_attribute)
        end
      end
    end
  end

  describe '#permalink' do
    before(:each) do
      allow(company).to receive(:name).and_return('FOO BAR')
    end

    it 'calls parameterize on the name' do
      expect(company.name).to receive(:parameterize)
      company.permalink
    end
  end

  describe '#agency?' do
    context 'when @agency is null' do
      let(:status) { 'status' }

      before(:each) do
        allow(company).to receive(:has_agency_category?).and_return(status)
      end
      after(:each) do
        company.instance_eval { @agency = nil }
      end

      it 'calls #has_agency_category?' do
        expect(company).to receive(:has_agency_category?)
        company.agency?
      end
      it 'returns value for @agency' do
        company.agency?
        actual = company.instance_eval { @agency }
        expect(actual).to eq status
      end
    end

    context 'when @agency is NOT null' do
      before(:each) do
        company.instance_eval { @agency = true }
      end
      after(:each) do
        company.instance_eval { @agency = nil }
      end

      it 'does NOT call #has_agency_category?' do
        expect(company).not_to receive(:has_agency_category?)
        company.agency?
      end
      it 'returns value of @agency' do
        actual = company.agency?
        expect(actual).to be_truthy
      end
    end
  end

  describe '#has_agency_category?' do
    let(:category_names) { %I(foo bar) }

    before(:each) do
      allow(company).to receive(:category_names).and_return(category_names)
    end
    after(:each) do
      company.send(:has_agency_category?)
    end

    it 'calls #category_names' do
      expect(company).to receive(:category_names)
    end
    it 'calls #include? on the category_names' do
      agency_category = described_class::AGENCY_CATEGORY
      expect(category_names).to receive(:include?).with(agency_category)
    end
  end
end
