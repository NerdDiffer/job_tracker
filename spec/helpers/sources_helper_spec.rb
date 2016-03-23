require 'rails_helper'

describe SourcesHelper, type: :helper do
  describe '#generate_select_opts_for_source_names' do
    let(:foo) { build(:source, name: 'foo', id: 1) }
    let(:bar) { build(:source, name: 'bar', id: 2) }
    let(:all_sources) { [foo, bar] }

    before(:each) do
      allow(helper).to receive(:fetch_all_sources).and_return(all_sources)
      allow(helper).to receive(:collect).with((foo), {}).and_return({ foo: 1 })
      allow(helper)
        .to receive(:collect)
        .with((bar), { foo: 1 })
        .and_return({ foo: 1, bar: 2 })
    end
    after(:each) do
      helper.send(:generate_select_opts_for_source_names)
    end

    it 'calls #fetch_all_sources' do
      # An 'early' return by stubbing a return value after expecting the call
      # to  #fetch_all_sources
      expect(helper).to receive(:fetch_all_sources).and_return([])
    end
    it 'calls #each_with_object on all_sources' do
      expect(all_sources).to receive(:each_with_object)
    end
    it 'calls #collect' do
      n = all_sources.length
      expect(helper).to receive(:collect).exactly(n).times
    end
  end

  describe '#fetch_all_sources' do
    before(:each) do
      allow(Source).to receive(:sorted).and_return(true)
    end

    it 'sets an ivar, @sources' do
      actual = helper.send(:fetch_all_sources)
      expect(actual).not_to be_nil
    end
    it 'calls .sorted on Source' do
      expect(Source).to receive(:sorted)
      helper.send(:fetch_all_sources)
    end
  end

  describe '#collect' do
    let(:source)  { build(:source) }
    let(:sources) { {} }

    before(:each) do
      allow(source).to receive(:display_name).and_return('FooBar')
      allow(source).to receive(:id).and_return(1)
    end

    it 'calls #display_name on the source' do
      expect(source).to receive(:display_name)
      helper.send(:collect, source, sources)
    end
    it 'calls #id on the source' do
      expect(source).to receive(:id)
      helper.send(:collect, source, sources)
    end
    it 'produces a hash' do
      actual = helper.send(:collect, source, sources)
      expected = { 'FooBar' => 1 }
      expect(actual).to eq expected
    end
  end
end
