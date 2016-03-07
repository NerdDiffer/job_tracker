require 'rails_helper'

describe SearchSuggestion::Refresh do
  let(:dummy_class) { double('Class', find_each: true) }
  let(:dictionary)  { SearchSuggestion::Dictionary.new('foo', dummy_class) }
  let(:rec_key_name) { 'foo' }
  let(:value)        { 'bar' }
  let(:glob_member)  { 'bar*' }

  describe '#unionize_sets!' do
    before(:each) do
      allow(dictionary).to receive(:union_key).and_return('foobar')
      allow(dictionary).to receive(:glob_keys).and_return([:foo, :bar])
      allow(REDIS_CLIENT).to receive(:zunionstore).and_return(true)
    end

    it 'calls #zunionstore on the redis client' do
      expect(REDIS_CLIENT).to receive(:zunionstore).with('foobar', [:foo, :bar])
      dictionary.send(:unionize_sets!)
    end
  end

  describe '#populate_sets' do
    before(:each) do
      allow(dummy_class).to receive(:find_each).and_yield(:foo).and_yield(:bar)
      allow(dictionary).to receive(:model).and_return(dummy_class)
      allow(dictionary).to receive(:process_value).and_return(value)
      allow(SearchSuggestion::KeyName)
        .to receive(:generic)
        .and_return(rec_key_name)
      allow(dictionary).to receive(:process_record).and_return(true)
    end
    after(:each) do
      dictionary.send(:populate_sets)
    end

    it 'calls #find_each on the model' do
      expect(dummy_class).to receive(:find_each)
    end
    it 'calls #process_value' do
      expect(dictionary)
        .to receive(:process_value)
        .with(:foo, :name)
        .with(:bar, :name)
    end
    it 'calls #key_name' do
      expect(SearchSuggestion::KeyName)
        .to receive(:generic)
        .with(dictionary.base_key, value)
    end
    it 'calls #process_record' do
      expect(dictionary).to receive(:process_record).with(rec_key_name, value)
    end
  end

  describe '#process_value' do
    let(:raw_value) { '  bar  ' }
    let(:record)    { double('record', foo: raw_value) }

    before(:each) do
      allow(record).to receive(:public_send).and_return(raw_value)
      allow(raw_value).to receive(:strip).and_return(value)
    end
    after(:each) do
      dictionary.send(:process_value, record, :foo)
    end

    it 'calls #public_send on the record' do
      expect(record).to receive(:public_send).with(:foo)
    end
    it 'calls #strip on the raw value' do
      expect(raw_value).to receive(:strip)
    end
  end

  describe '#process_record' do
    before(:each) do
      allow(value).to receive(:length).and_return(3)
      allow(dictionary).to receive(:process_members).and_return(true)
    end
    after(:each) do
      dictionary.send(:process_record, rec_key_name, value)
    end
    it 'calls #process_members' do
      expect(dictionary)
        .to receive(:process_members)
        .with(rec_key_name, value, (1..3))
    end
  end

  describe '#process_members' do
    let(:range) { (0..5) }
    before(:each) do
      allow(dictionary).to receive(:add_to_sorted_set!).and_return(true)
      allow(dictionary).to receive(:append_with_glob_member!).and_return(true)
    end
    after(:each) do
      dictionary.send(:process_members, rec_key_name, value, range)
    end

    it 'calls #each on the range' do
      expect(range).to receive(:each)
    end
    it 'calls #add_to_sorted_set' do
      expect(dictionary)
        .to receive(:add_to_sorted_set!)
        .exactly(range.size).times
    end
    it 'calls #append_with_glob_member' do
      expect(dictionary).to receive(:append_with_glob_member!)
    end
  end

  describe '#add_to_sorted_set!' do
    before(:each) do
      allow(dictionary).to receive(:member_for_sorted_set).and_return(value)
      allow(REDIS_CLIENT).to receive(:zadd).and_return(true)
    end
    after(:each) do
      dictionary.send(:add_to_sorted_set!, rec_key_name, value, 1)
    end

    it 'calls #member_for_sorted_set' do
      expect(dictionary).to receive(:member_for_sorted_set)
    end
    it 'calls "zadd" on redis client' do
      expect(REDIS_CLIENT).to receive(:zadd).with(rec_key_name, 0, value)
    end
  end

  describe '#append_with_glob_member!' do
    before(:each) do
      allow(value).to receive(:+).with('*').and_return(glob_member)
      allow(REDIS_CLIENT).to receive(:zadd).and_return(true)
    end
    after(:each) do
      dictionary.send(:append_with_glob_member!, rec_key_name, value)
    end

    it 'puts a "*" at end of the value' do
      expect(value).to receive(:+).with('*')
    end
    it 'calls "zadd" on redis client' do
      expect(REDIS_CLIENT).to receive(:zadd).with(rec_key_name, 0, glob_member)
    end
  end

  describe '#member_for_sorted_set' do
    it 'calls :[] with a range' do
      value = 'foobar'
      index_of_range = 2
      expect(value).to receive(:[]).with((0...2))
      dictionary.send(:member_for_sorted_set, value, index_of_range)
    end
  end

  describe '#delete_union_set!' do
    before(:each) do
      allow(dictionary).to receive(:union_key).and_return('foobar')
      allow(REDIS_CLIENT).to receive(:del).and_return(true)
    end
    it 'calls "del" on redis client' do
      expect(REDIS_CLIENT).to receive(:del).with('foobar')
      dictionary.send(:delete_union_set!)
    end
  end

  describe '#delete_record_sets!' do
    before(:each) do
      allow(dictionary).to receive(:glob_keys).and_return([:foo, :bar])
      allow(REDIS_CLIENT).to receive(:del).and_return(true)
    end
    after(:each) do
      dictionary.send(:delete_record_sets!)
    end
    it 'calls glob_keys' do
      expect(dictionary).to receive(:glob_keys)
    end
    it 'calls "del" on redis client' do
      expect(REDIS_CLIENT).to receive(:del).with(:foo).with(:bar)
    end
  end

  describe '#glob_keys' do
    before(:each) do
      allow(SearchSuggestion::KeyName).to receive(:generic).and_return(true)
      allow(REDIS_CLIENT).to receive(:keys).and_return(true)
    end
    after(:each) do
      dictionary.send(:glob_keys)
    end

    it 'calls key_name' do
      expect(SearchSuggestion::KeyName)
        .to receive(:generic)
        .with(dictionary.base_key, '*')
    end
    it 'calls "keys" on redis client' do
      expect(REDIS_CLIENT).to receive(:keys)
    end
  end
end
