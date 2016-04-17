require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact, id: 1) }
  let(:company) { build(:company) }

  describe '.get_record_val_by' do
    context 'searching by real attributes' do
      before(:each) do
        allow(described_class)
          .to receive(:find_by_first_name)
          .with(instance_of(String))
          .and_return contact
      end

      it 'returns id of contact' do
        actual = described_class.get_record_val_by(:first_name, 'foo')
        expect(actual).to eq 1
      end
    end
  end

  describe '#permalink' do
    it 'calls parameterize on the name' do
      allow(contact).to receive(:name).and_return('FOO BAR')
      # `parameterize` is called upon a singleton object, not the String class
      expect(contact.name).to receive(:parameterize)
      contact.permalink
    end
  end

  describe '#name' do
    before(:each) do
      allow(contact).to receive(:first_name).and_return('Foo')
      allow(contact).to receive(:last_name).and_return('Bar')
    end

    it 'calls #first_name' do
      expect(contact).to receive(:first_name)

      contact.name
    end
    it 'calls #last_name' do
      expect(contact).to receive(:last_name)

      contact.name
    end
    it 'returns first & last name' do
      expect(contact.name).to eq 'Foo Bar'
    end
  end

  describe '#company_name' do
    after(:each) do
      contact.company_name
    end

    it 'calls #company?' do
      allow(contact).to receive(:company_id?).and_return(false)
      expect(contact).to receive(:company_id?)
    end

    context 'when a contact belongs to a company' do
      before(:each) do
        allow(contact).to receive(:company_id?).and_return(true)
        allow(contact).to receive(:company).and_return(company)
      end

      it 'calls for #name on the company' do
        expect(company).to receive(:name)
      end
    end
    context 'when a contact does NOT belong to a company' do
      before(:each) do
        allow(contact).to receive(:company_id?).and_return(false)
      end

      it 'returns nil' do
        expect(contact.company_name).to be_nil
      end
    end
  end
end
