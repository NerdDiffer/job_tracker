require 'rails_helper'

describe SearchSuggestion::Refresh::Model do
  class DummyClass
    include SearchSuggestion::Refresh::Model

    def name
      'name'
    end

    def names_base_key
      'names_base_key'
    end
  end

  let(:dummy) { DummyClass.new }
  let(:model_key) { 'model_key' }
  let(:all_names_keys) { 'all_names_keys' }

  describe '#delete_redis_keys!' do
    before(:each) do
      allow(dummy).to receive(:model_key).and_return(model_key)
      allow(REDIS_CLIENT).to receive(:del).and_return(true)
    end
    after(:each) do
      dummy.send(:delete_redis_keys!)
    end

    it 'calls #same_count?' do
      allow(dummy).to receive(:same_count?).and_return(false)
      allow(dummy).to receive(:remove_model_keys_only)
      expect(dummy).to receive(:same_count?)
    end

    context 'if #same_count? is true' do
      it 'calls #zremrangebylex' do
        allow(dummy).to receive(:same_count?).and_return(true)
        allow(dummy).to receive(:zremrangebylex).and_return(true)
        allow(dummy).to receive(:all_names_keys).and_return(all_names_keys)
        allow(dummy).to receive(:name).and_return('foo')
        expect(dummy).to receive(:zremrangebylex)
      end
    end
    context 'if #same_count? is false' do
      it 'calls #remove_model_keys_only' do
        allow(dummy).to receive(:same_count?).and_return(false)
        allow(dummy).to receive(:remove_model_keys_only)
        expect(dummy).to receive(:remove_model_keys_only)
      end
    end

    it 'calls #del on the redis client' do
      allow(dummy).to receive(:same_count?).and_return(false)
      allow(dummy).to receive(:remove_model_keys_only)
      expect(REDIS_CLIENT).to receive(:del).with(model_key)
      dummy.send(:delete_redis_keys!)
    end
  end

  describe '#names_key' do
    it 'calls a method on KeyName module' do
      allow(SearchSuggestion::KeyName).to receive(:base)
      expect(SearchSuggestion::KeyName)
        .to receive(:base)
        .with(dummy.names_base_key)
      dummy.send(:names_key)
    end
  end

  describe '#all_names_keys' do
    it 'calls a method on KeyName module' do
      allow(SearchSuggestion::KeyName).to receive(:base)
      expect(SearchSuggestion::KeyName)
        .to receive(:union)
        .with(dummy.names_base_key)
      dummy.send(:all_names_keys)
    end
  end

  describe '#model_key' do
    it 'calls a method on KeyName module' do
      allow(SearchSuggestion::KeyName).to receive(:base)
      expect(SearchSuggestion::KeyName)
        .to receive(:generic)
        .with(dummy.names_base_key, dummy.name)
      dummy.send(:model_key)
    end
  end

  describe '#lex_min' do
    it 'ends up with this string' do
      allow(dummy).to receive(:name).and_return('foo')
      actual = dummy.send(:lex_min)
      expect(actual).to eq '[f'
    end
  end

  describe '#lex_max' do
    it 'ends up with this string' do
      allow(dummy).to receive(:name).and_return('foo')
      actual = dummy.send(:lex_max)
      expect(actual).to eq '[foo*'
    end
  end

  describe '#zlexcount' do
    let(:range) { 'range' }

    before(:each) do
      allow(REDIS_CLIENT).to receive(:zrangebylex).and_return(range)
      allow(range).to receive(:length).and_return(5)
    end
    after(:each) do
      dummy.send(:zlexcount, 'keyspace', 0, 1)
    end

    it 'calls #zrangebylex on redis client' do
      expect(REDIS_CLIENT).to receive(:zrangebylex).with('keyspace', 0, 1)
    end
    it 'calls #length on the range returned by call to #zrangebylex on redis' do
      expect(range).to receive(:length)
    end
  end

  describe '#lex_count_model' do
    before(:each) do
      allow(dummy).to receive(:model_key).and_return(model_key)
      allow(dummy).to receive(:zlexcount).and_return(true)
    end

    it 'calls #zlexcount with "-" and "+"' do
      expect(dummy).to receive(:zlexcount).with(model_key, '-', '+')
      dummy.send(:lex_count_model)
    end
  end

  describe '#lex_count_all' do
    before(:each) do
      allow(dummy).to receive(:all_names_keys).and_return(all_names_keys)
      allow(dummy).to receive(:lex_min).and_return(0)
      allow(dummy).to receive(:lex_max).and_return(1)
      allow(dummy).to receive(:zlexcount).and_return(true)
    end
    after(:each) do
      dummy.send(:lex_count_all)
    end

    it 'calls #all_names_keys' do
      expect(dummy).to receive(:all_names_keys)
    end
    it 'calls #lex_min' do
      expect(dummy).to receive(:lex_min)
    end
    it 'calls #lex_max' do
      expect(dummy).to receive(:lex_max)
    end
    it 'calls #zlexcount' do
      expect(dummy).to receive(:zlexcount).with(all_names_keys, 0, 1)
    end
  end

  describe '#same_count?' do
    let(:lex_count_model) { '5' }
    let(:lex_count_all)   { '10' }

    before(:each) do
      allow(dummy).to receive(:lex_count_model).and_return(lex_count_model)
      allow(dummy).to receive(:lex_count_all).and_return(lex_count_all)
    end

    it 'compares #lex_count_model and #lex_count_all' do
      expect(lex_count_model).to receive(:==).with(lex_count_all)
      dummy.send(:same_count?)
    end
  end

  describe '#lex_range' do
    before(:each) do
      allow(dummy).to receive(:all_names_keys).and_return('all_names_keys')
      allow(dummy).to receive(:lex_min).and_return(0)
      allow(dummy).to receive(:lex_max).and_return(1)
      allow(REDIS_CLIENT).to receive(:zrangebylex).and_return(true)
    end

    it 'calls #zrangebylex on redis client' do
      expect(REDIS_CLIENT)
        .to receive(:zrangebylex)
        .with('all_names_keys', 0, 1)
      dummy.send(:lex_range)
    end
  end

  describe '#zremrangebylex' do
    let(:lex_range) { [:foo, :bar] }

    before(:each) do
      allow(dummy).to receive(:lex_range).and_return(lex_range)
      allow(dummy).to receive(:all_names_keys).and_return('all_names_keys')
      allow(REDIS_CLIENT).to receive(:zrem).and_return(true)
    end
    after(:each) do
      dummy.send(:zremrangebylex)
    end

    it 'calls #lex_range' do
      expect(dummy).to receive(:lex_range)
    end
    it 'calls #each on range returned by #lex_range' do
      expect(lex_range).to receive(:each)
    end
    it 'calls #zrem on redis client' do
      expect(REDIS_CLIENT)
        .to receive(:zrem)
        .with('all_names_keys', :foo)
        .with('all_names_keys', :bar)
    end
  end

  describe '#remove_model_keys_only' do
    let(:other_names) { [:alpha, :beta, :charlie] }
    let(:lex_range)   { [:foo, :bar] }

    before(:each) do
      allow(dummy).to receive(:prepare_other_set_names).and_return(other_names)
      allow(dummy).to receive(:lex_range).and_return(lex_range)
      allow(dummy).to receive(:all_names_keys).and_return('all_names_keys')
    end
    after(:each) do
      dummy.send(:remove_model_keys_only)
    end

    it 'calls #prepare_other_set_names' do
      expect(dummy).to receive(:prepare_other_set_names)
    end
    it 'calls #lex_range' do
      expect(dummy).to receive(:lex_range)
    end
    it 'calls #each on results of #lex_range' do
      expect(lex_range).to receive(:each)
    end
    it 'calls #each on results of #lex_range' do
      n = lex_range.length
      expect(dummy).to receive(:remove_unless_member_of_another).exactly(n).times
    end
  end

  describe '#remove_unless_member_of_another' do
    let(:member) { 'member' }
    let(:names) { [:foo, :food] }

    before(:each) do
      allow(REDIS_CLIENT).to receive(:zrem).and_return(true)
    end
    after(:each) do
      dummy.send(:remove_unless_member_of_another, names, member)
    end

    it 'calls #member_of_another?' do
      allow(dummy).to receive(:member_of_another?).and_return(true)
      expect(dummy).to receive(:member_of_another?).with(names, member)
    end

    context 'when #member_of_another? is true' do
      before(:each) do
        allow(dummy).to receive(:member_of_another?).and_return(true)
      end

      it 'does NOT call #zrem on redis client' do
        expect(REDIS_CLIENT).not_to receive(:zrem)
      end
    end

    context 'when #member_of_another? is false' do
      before(:each) do
        allow(dummy).to receive(:member_of_another?).and_return(false)
        allow(dummy).to receive(:all_names_keys).and_return(all_names_keys)
      end

      it 'calls #zrem on redis client' do
        expect(REDIS_CLIENT).to receive(:zrem).with(all_names_keys, member)
      end
    end
  end

  describe '#prepare_other_set_names' do
    let(:selected_range) { %w(bar* foo*) }
    let(:mapped_range)   { %w(bar foo) }

    before(:each) do
      allow(dummy).to receive(:select_globbed_members).and_return(selected_range)
      allow(selected_range).to receive(:map).and_return(mapped_range)
      allow(mapped_range).to receive(:reject)
    end
    after(:each) do
      dummy.send(:prepare_other_set_names)
    end

    it 'calls #select_globbed_members' do
      expect(dummy).to receive(:select_globbed_members)
    end
    it 'calls #map!' do
      expect(selected_range).to receive(:map)
    end
    it 'calls #reject' do
      expect(mapped_range).to receive(:reject)
    end
  end

  describe '#select_globbed_members' do
    let(:lex_range) { %w(b ba bar bar* f fo foo foo* ) }

    before(:each) do
      allow(dummy).to receive(:lex_range).and_return(lex_range)
    end
    after(:each) do
      dummy.send(:select_globbed_members)
    end

    it 'calls #lex_range' do
      expect(dummy).to receive(:lex_range)
    end
    it 'calls #select on results on #lex_range' do
      expect(lex_range).to receive(:select)
    end
    it 'calls #last_char_glob?' do
      n = lex_range.length
      expect(dummy).to receive(:last_char_glob?).exactly(n).times
    end
  end

  describe '#last_char_glob?' do
    let(:member) { 'foo*' }
    let(:last_char) { '*' }

    before(:each) do
      allow(member).to receive(:[]).and_return(last_char)
      allow(last_char).to receive(:==).and_return(true)
    end
    after(:each) do
      dummy.send(:last_char_glob?, member)
    end

    it 'calls [] on the passed on value' do
      range = (-1..-1)
      expect(member).to receive(:[]).with(range)
    end
    it 'calls == on the last character' do
      glob = '*'
      expect(last_char).to receive(:==).with(glob)
    end
  end

  describe '#member_of_another?' do
    let(:list) { [:foo, :bar] }
    let(:val)  { 'val' }

    before(:each) do
      allow(dummy).to receive(:names_key).and_return('names_key')
      allow(REDIS_CLIENT).to receive(:zrank)
    end
    after(:each) do
      dummy.send(:member_of_another?, list, val)
    end

    it 'calls #any? on the passed in list' do
      expect(list).to receive(:any?)
    end
    it 'calls #zrank on the redis client' do
      expect(REDIS_CLIENT)
        .to receive(:zrank)
        .with('names_key:foo', val)
        .with('names_key:bar', val)
    end
  end
end
