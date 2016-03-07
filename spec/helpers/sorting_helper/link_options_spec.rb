require 'rails_helper'

describe SortingHelper::LinkOptions, type: :helper do
  class Dummy
    include SortingHelper::LinkOptions

    attr_reader :link_options

    def params
      # no op
    end
  end

  let(:dummy) { Dummy.new }

  describe '#link_options!' do
    before(:each) do
      allow(dummy).to receive(:active?).and_return(true)
      allow(dummy).to receive(:active!).and_return(true)
      allow(dummy).to receive(:category_names?).and_return(true)
      allow(dummy).to receive(:category_names!).and_return(true)
      allow(dummy).to receive(:search?).and_return(true)
      allow(dummy).to receive(:search!).and_return(true)
    end
    after(:each) do
      dummy.link_options!
    end

    it 'calls #active?' do
      expect(dummy).to receive(:active?)
    end
    it 'calls #active!' do
      expect(dummy).to receive(:active!)
    end
    it 'calls #category_names?' do
      expect(dummy).to receive(:category_names?)
    end
    it 'calls #category_names!' do
      expect(dummy).to receive(:category_names!)
    end
    it 'calls #search?' do
      expect(dummy).to receive(:search?)
    end
    it 'calls #search!' do
      expect(dummy).to receive(:search!)
    end
  end

  describe 'methods related to :active' do
    let(:active) { 'active' }
    let(:params) { { active: active } }

    before(:each) do
      allow(dummy).to receive(:params).and_return(params)
    end

    describe '#active?' do
      after(:each) do
        dummy.send(:active?)
      end

      it 'calls #params' do
        expect(dummy).to receive(:params)
      end
      it 'calls #present? on the :active key of params' do
        expect(active).to receive(:present?)
      end
    end

    describe '#active' do
      it 'calls #params' do
        expect(dummy).to receive(:params)
        dummy.send(:active)
      end
      it 'returns value at :active key' do
        actual = dummy.send(:active)
        expect(actual).to eq 'active'
      end
    end

    describe '#active!' do
      before(:each) do
        dummy.instance_eval { @link_options = {} }
        allow(dummy).to receive(:active).and_return(active)
      end
      after(:each) do
        dummy.instance_eval { @link_options = nil }
      end

      it 'sets a value to @link_options at :active key' do
        expect(dummy.link_options).to eq({})
        dummy.send(:active!)
        expect(dummy.link_options).to eq({ active: active })
      end
    end
  end


  describe 'methods related to :category_names' do
    let(:category_names) { 'category_names' }
    let(:params) { { category_names: category_names } }

    before(:each) do
      allow(dummy).to receive(:params).and_return(params)
    end

    describe '#category_names?' do
      after(:each) do
        dummy.send(:category_names?)
      end

      it 'calls #params' do
        expect(dummy).to receive(:params)
      end
      it 'calls #present? on the :category_names key of params' do
        expect(category_names).to receive(:present?)
      end
    end

    describe '#category_names' do
      it 'calls #params' do
        expect(dummy).to receive(:params)
        dummy.send(:category_names)
      end
      it 'returns value at :category_names key' do
        actual = dummy.send(:category_names)
        expect(actual).to eq 'category_names'
      end
    end

    describe '#category_names!' do
      before(:each) do
        dummy.instance_eval { @link_options = {} }
        allow(dummy).to receive(:category_names).and_return(category_names)
      end
      after(:each) do
        dummy.instance_eval { @link_options = nil }
      end

      it 'sets a value to @link_options at :category_names key' do
        expect(dummy.link_options).to eq({})
        dummy.send(:category_names!)
        expect(dummy.link_options).to eq({ category_names: category_names })
      end
    end
  end

  describe 'methods related to :search' do
    let(:search) { 'search' }
    let(:params) { { search: search } }

    before(:each) do
      allow(dummy).to receive(:params).and_return(params)
    end

    describe '#search?' do
      after(:each) do
        dummy.send(:search?)
      end

      it 'calls #params' do
        expect(dummy).to receive(:params)
      end
      it 'calls #present? on the :search key of params' do
        expect(search).to receive(:present?)
      end
    end

    describe '#search' do
      it 'calls #params' do
        expect(dummy).to receive(:params)
        dummy.send(:search)
      end
      it 'returns value at :search key' do
        actual = dummy.send(:search)
        expect(actual).to eq 'search'
      end
    end

    describe '#search!' do
      before(:each) do
        dummy.instance_eval { @link_options = {} }
        allow(dummy).to receive(:search).and_return(search)
      end
      after(:each) do
        dummy.instance_eval { @link_options = nil }
      end

      it 'sets a value to @link_options at :search key' do
        expect(dummy.link_options).to eq({})
        dummy.send(:search!)
        expect(dummy.link_options).to eq({ search: search })
      end
    end
  end
end
