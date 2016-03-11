require 'rails_helper'

describe CompaniesCategoriesHelper do
  describe '#display_names' do
    let(:names) { %w(foo bar qux) }
    let(:opts) { { delimiter: ' - ' } }

    before(:each) do
      allow(helper).to receive(:delimiter).and_return(' - ')
      allow(helper).to receive(:join_list)
    end
    after(:each) do
      helper.display_names(names, opts)
    end

    it 'calls #delimiter' do
      expect(helper).to receive(:delimiter).with(opts)
    end
    it 'calls #join_list' do
      expect(helper).to receive(:join_list).with(names, ' - ')
    end
  end

  describe '#generate_select_opts_for_category_names' do
    let(:foo) { double('foo') }
    let(:bar) { double('bar') }
    let(:all_categories) { [foo, bar] }

    before(:each) do
      allow(helper).to receive(:fetch_all_categories).and_return(all_categories)
      allow(foo).to receive(:display_name).and_return('foo')
      allow(bar).to receive(:display_name).and_return('bar')
    end
    after(:each) do
      helper.generate_select_opts_for_category_names
    end

    it 'calls #fetch_all_categories' do
      expect(helper).to receive(:fetch_all_categories)
    end
    it 'calls #map on all_categories' do
      expect(all_categories).to receive(:map)
    end
    it 'calls #display_name' do
      expect(foo).to receive(:display_name)
      expect(bar).to receive(:display_name)
    end
  end

  describe '#delimiter' do
    context 'when passed in options has the key, :delimiter' do
      let(:delimiter) { 'foo' }

      it 'returns value at that key' do
        actual = helper.send(:delimiter, { delimiter: delimiter })
        expect(actual).to eq delimiter
      end
    end
    context 'when passed in options does NOT have the key, :delimiter' do
      it 'returns the default delimiter' do
        actual = helper.send(:delimiter, { foo: 'bar' })
        expect(actual).to eq ', '
      end
    end
  end

  describe '#join_list' do
    let(:arr) { %w(foo bar qux) }
    let(:delimiter) { ', ' }

    it 'calls #join on the passed-in list' do
      allow(arr).to receive(:join)
      expect(arr).to receive(:join).with(delimiter)
      helper.send(:join_list, arr, delimiter)
    end
  end

  describe '#fetch_all_categories' do
    before(:each) do
      allow(Category).to receive(:sorted).and_return(true)
    end

    it 'sets an ivar, @categories' do
      actual = helper.send(:fetch_all_categories)
      expect(actual).not_to be_nil
    end
    it 'calls .all on Category' do
      expect(Category).to receive(:sorted)
      helper.send(:fetch_all_categories)
    end
  end
end
