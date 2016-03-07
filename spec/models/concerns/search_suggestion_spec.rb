require 'rails_helper'

describe SearchSuggestion do
  shared_examples_for 'refreshing a Dictionary object' do
    before(:each) do
      allow(SearchSuggestion::Dictionary)
        .to receive(:new)
        .and_return(SearchSuggestion::Dictionary.new(base_key, model))
      allow_any_instance_of(SearchSuggestion::Dictionary).to receive(:refresh)
    end

    it 'creates a Dictionary instance' do
      expect(SearchSuggestion::Dictionary).to receive(:new)
    end
    it 'calls refresh on the dictionary' do
      expect_any_instance_of(SearchSuggestion::Dictionary).to receive(:refresh)
    end
  end

  describe '.refresh_category_names' do
    it_behaves_like 'refreshing a Dictionary object' do
      let(:base_key) { 'category_names' }
      let(:model)    { Category }

      after(:each) do
        described_class.refresh_category_names
      end

      it 'passes this value for base_key' do
        expect(base_key).to eq 'category_names'
      end

      it 'passes this value for model' do
        expect(model).to eq Category
      end
    end
  end

  describe '.refresh_company_names' do
    it_behaves_like 'refreshing a Dictionary object' do
      let(:base_key) { 'company_names' }
      let(:model)    { Company }

      after(:each) do
        described_class.refresh_company_names
      end

      it 'passes this value for base_key' do
        expect(base_key).to eq 'company_names'
      end

      it 'passes this value for model' do
        expect(model).to eq Company
      end
    end
  end

  describe '.terms_for' do
    let(:dummy_class) { Class.new }
    let(:dictionary)  { SearchSuggestion::Dictionary.new('bar', dummy_class) }
    let(:search)      { SearchSuggestion::Search.new('foo', 'bar') }

    before(:each) do
      allow(described_class)
        .to receive(:select_dictionary)
        .and_return(dictionary)
      allow(dictionary).to receive(:search).and_return(search)
      allow(search).to receive(:results).and_return([])
    end
    after(:each) do
      described_class.terms_for('foo', 'bar')
    end

    it 'calls .select_dictionary with a hash with the key :base_key' do
      expect(described_class)
        .to receive(:select_dictionary)
        .with('bar')
    end
    it 'calls .search with the query' do
      expect(dictionary)
        .to receive(:search)
        .with('foo')
    end
  end

  describe '.select_dictionary' do
    context 'when base_key is "category_names"' do
      it 'calls Dictionary.new with these arguments' do
        expect(SearchSuggestion::Dictionary)
          .to receive(:new)
          .with('category_names', Category)
        described_class.send(:select_dictionary, 'category_names')
      end
    end

    context 'when base_key is NOT "category_names"' do
      it 'calls Dictionary.new with these arguments' do
        expect(SearchSuggestion::Dictionary)
          .to receive(:new)
          .with('company_names', Company)
        described_class.send(:select_dictionary, 'company_names')
      end
    end
  end
end
