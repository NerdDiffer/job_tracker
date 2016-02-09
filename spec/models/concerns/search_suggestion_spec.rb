require 'rails_helper'

RSpec.describe SearchSuggestion, type: :model do
  describe '.refresh_contact_names' do
    before(:each) do
      allow(described_class)
        .to receive(:contact_names_key)
        .and_return('foo_bar:contact_names')
      expect(described_class).to receive(:contact_names_key)
    end

    it 'calls .delete_by' do
      expect(described_class)
        .to receive(:delete_by)
        .with('foo_bar:contact_names')
      described_class.refresh_contact_names
    end
    it 'calls .seed' do
      allow(described_class).to receive(:delete_by).and_return(true)
      expect(described_class)
        .to receive(:seed)
        .with(Contact, :name, 'foo_bar:contact_names')
      described_class.refresh_contact_names
    end
  end

  describe '.refresh_company_names' do
    before(:each) do
      allow(described_class)
        .to receive(:company_names_key)
        .and_return('foo_bar:company_names')
      expect(described_class).to receive(:company_names_key)
    end

    it 'calls .delete_by' do
      expect(described_class)
        .to receive(:delete_by)
        .with('foo_bar:company_names')
      described_class.refresh_company_names
    end
    it 'calls .seed' do
      allow(described_class).to receive(:delete_by).and_return(true)
      expect(described_class)
        .to receive(:seed)
        .with(Company, :name, 'foo_bar:company_names')
      described_class.refresh_company_names
    end
  end

  describe '.terms_for' do
    terms_for_attr = { max: 5, parent_set: 'foo' }

    before(:each) do
      allow($redis).to receive(:zrevrange).and_return(true)
    end

    it 'calls .key_name' do
      expect(described_class).to receive(:key_name)
      described_class.terms_for('quux', terms_for_attr)
    end

    it 'calls #zrevrange on the redis object' do
      allow(described_class).to receive(:key_name).and_return('bar')
      expect($redis).to receive(:zrevrange)
      described_class.terms_for('quux', terms_for_attr)
    end
  end

  describe '.seed' do
    let(:contact) { build(:contact) }

    it 'calls .find_each on the model' do
      allow(Contact).to receive(:find_each).and_return(nil)
      expect(Contact).to receive(:find_each)
      described_class.send(:seed, Contact, :attribute, :namespace_key)
    end

    context 'iterating on each record' do
      namespace_key = described_class.contact_names_key

      before(:each) do
        allow(Contact).to receive(:find_each).and_yield(contact)
      end
      after(:each) do
        described_class.send(:seed, Contact, :name, namespace_key)
      end

      it 'gets attribute value with .public_send' do
        expect(contact).to receive(:public_send).with(:name)
        allow(described_class).to receive(:downcase_strip).and_return('foo')
        allow(described_class).to receive(:generate_sets)
      end
      it 'calls .downcase_strip' do
        allow(contact).to receive(:name).and_return('foo')
        expect(described_class).to receive(:downcase_strip).and_return('foo')
        allow(described_class).to receive(:generate_sets)
      end
      it 'calls .generate_sets' do
        allow(contact).to receive(:name).and_return('foo')
        allow(described_class).to receive(:downcase_strip).and_return('foo')
        expect(described_class).to receive(:generate_sets)
      end
    end
  end

  describe '.delete_by' do
    before(:each) do
      allow(described_class).to receive(:key_name).and_return('foo:*')
      allow($redis).to receive(:keys).and_return([:foo, :bar])
      allow($redis).to receive(:del).and_return(true)
    end
    after(:each) do
      described_class.send(:delete_by, 'foo')
    end

    it 'calls key_name' do
      expect(described_class).to receive(:key_name)
    end
    it 'calls #keys on redis object' do
      expect($redis).to receive(:keys).with('foo:*')
    end
    it 'calls #del on redis object' do
      expect($redis).to receive(:del)
    end
  end

  describe '.key_name' do
    it 'returns a string in the format `arg1:arg2`' do
      actual = described_class.send(:key_name, 'foo', 'bar')
      expect(actual).to match(/.*:.*/)
    end
  end
end
