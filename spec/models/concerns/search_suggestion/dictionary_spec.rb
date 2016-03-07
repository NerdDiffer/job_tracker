require 'rails_helper'

describe SearchSuggestion::Dictionary do
  let(:dummy_class) { Class.new }
  let(:dictionary)  { described_class.new('foo', dummy_class) }

  describe '#initialize' do
    it 'has these attributes & values' do
      new_dictionary = described_class.new('foo', dummy_class)
      expect(new_dictionary).to have_attributes(
        base_key: 'foo',
        union_key: 'job_tracker:ALL:foo',
        model: dummy_class
      )
    end

    describe 'methods called' do
      before(:each) do
        allow_any_instance_of(described_class)
          .to receive(:name_of_union_key)
          .and_return(true)
      end

      it 'calls #name_of_union_key' do
        expect_any_instance_of(described_class).to receive(:name_of_union_key)
        described_class.new('foo', dummy_class)
      end
    end
  end

  describe '#refresh' do
    before(:each) do
      allow(dictionary).to receive(:delete_union_set!).and_return(true)
      allow(dictionary).to receive(:delete_record_sets!).and_return(true)
      allow(dictionary).to receive(:populate_sets).and_return(true)
      allow(dictionary).to receive(:unionize_sets!).and_return(true)
    end
    after(:each) do
      dictionary.refresh
    end

    it 'calls delete_union_set!' do
      expect(dictionary).to receive(:delete_union_set!)
    end

    it 'calls delete_record_sets!' do
      expect(dictionary).to receive(:delete_record_sets!)
    end

    it 'calls populate_sets' do
      expect(dictionary).to receive(:populate_sets)
    end

    it 'calls unionize_sets!' do
      expect(dictionary).to receive(:unionize_sets!)
    end
  end

  describe '#search' do
    before(:each) do
      allow(dictionary).to receive(:union_key).and_return('union_key')
    end

    it 'creates a new Search object' do
      expect(SearchSuggestion::Search)
        .to receive(:new)
        .with('union_key', 'query', 15)
      dictionary.search('query')
    end
  end

  describe '#name_of_union_key' do
    it 'calls SearchSuggestion::KeyName.union' do
      allow(SearchSuggestion::KeyName).to receive(:union)
      expect(SearchSuggestion::KeyName).to receive(:union)
      dictionary.send(:name_of_union_key)
    end
  end
end
