require 'rails_helper'

describe CompaniesCategoriesHelper do
  let(:foo) { double('foo') }
  let(:bar) { double('bar') }
  let(:all_categories) { [foo, bar] }
  let(:company) { build(:company) }

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

  describe '#generate_category_checkboxes' do
    before(:each) do
      allow(helper).to receive(:fetch_all_categories).and_return(all_categories)
      allow(all_categories).to receive(:each).and_yield(foo).and_yield(bar)
    end

    it 'calls #fetch_all_categories' do
      expect(helper).to receive(:fetch_all_categories)
      helper.generate_category_checkboxes { |category| category }
    end
    it 'calls #each on all_categories' do
      expect(all_categories).to receive(:each)
      helper.generate_category_checkboxes { |category| category }
    end
    specify do
      expect { |block| helper.generate_category_checkboxes(&block) }
        .to yield_control
    end
  end

  describe '#checked?' do
    let(:category_ids) { [1, 2, 3] }

    before(:context) do
      allow_message_expectations_on_nil(true)
    end
    before(:each) do
      allow(helper).to receive(:company).and_return(company)
      allow(company).to receive(:category_ids).and_return(category_ids)
      allow(category_ids).to receive(:include?)
    end
    after(:each) do
      helper.checked?(1)
    end
    after(:context) do
      allow_message_expectations_on_nil(false)
    end

    it 'calls #company' do
      expect(helper).to receive(:company)
    end
    it 'calls #category_ids on company' do
      expect(company).to receive(:category_ids)
    end
    it 'calls #include? on category_ids' do
      expect(category_ids).to receive(:include?).with(1)
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
      allow(Category).to receive(:sorted).and_return(all_categories)
    end

    it 'calls .sorted on Category' do
      expect(Category).to receive(:sorted)
      helper.send(:fetch_all_categories)
    end
    it 'sets value for @categories' do
      expect { helper.send(:fetch_all_categories) }
        .to change { helper.instance_eval { @categories } }
        .from(nil).to all_categories
    end
  end

  private

  def allow_message_expectations_on_nil(bool)
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.allow_message_expectations_on_nil = bool
      end
    end
  end
end
