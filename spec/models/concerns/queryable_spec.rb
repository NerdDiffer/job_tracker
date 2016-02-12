require 'rails_helper'

class Dummy
  include Queryable

  attr_reader :name
end

RSpec.describe Queryable, type: :model do
  let(:model) { Dummy }
  let(:records) { (1..5).map { Dummy.new } }
  let(:attribute) { 'name' }
  let(:n) { records.length }

  describe '#sort_by_attribute' do
    it 'the records receive the #sort method' do
      expect(records).to receive(:sort)
      model.sort_by_attribute(records, attribute)
    end
    it 'calls #safe_compare' do
      allow(model).to receive(:safe_compare).and_return(0)
      expect(model).to receive(:safe_compare)
      model.sort_by_attribute(records, attribute)
    end
  end

  describe '#safe_compare' do
    let(:record_a) { records.first }
    let(:record_b) { records.second }

    before(:each) do
      allow(record_a)
        .to receive(:public_send)
        .with(attribute)
        .and_return('foo')
      allow(record_b)
        .to receive(:public_send)
        .with(attribute)
        .and_return('bar')
    end
    after(:each) do
      model.send(:safe_compare, record_a, record_b, attribute, 'asc')
    end

    it 'calls #public_send with the attribute' do
      expect(record_a).to receive(:public_send).with(attribute)
      expect(record_b).to receive(:public_send).with(attribute)
    end
    it 'receives #any_nil?' do
      expect(model).to receive(:any_nil?)
    end
    context 'when #any_nil? is true' do
      it 'receives #handle_nil' do
        allow(model).to receive(:any_nil?).and_return(true)
        expect(model).to receive(:handle_nil).and_return(0)
      end
    end
    context 'when #any_nil? is false' do
      it 'receives #compare with direction' do
        allow(model).to receive(:any_nil?).and_return(false)
        expect(model).to receive(:compare).and_return(0)
      end
    end
  end

  describe '#any_nil?' do
    it 'returns true if either of the parameters are nil' do
      actual = model.send(:any_nil?, nil, nil)
      expect(actual).to be_truthy
      actual = model.send(:any_nil?, :foo, nil)
      expect(actual).to be_truthy
      actual = model.send(:any_nil?, nil, :bar)
      expect(actual).to be_truthy
    end
    it 'otherwise returns false' do
      actual = model.send(:any_nil?, :foo, :bar)
      expect(actual).to be_falsey
    end
  end

  describe '#handle_nil' do
    it 'returns 0 if both are nil' do
      actual = model.send(:handle_nil, nil, nil)
      expect(actual).to eq 0
    end
    it 'returns 1 if first argument is nil' do
      actual = model.send(:handle_nil, nil, :bar)
      expect(actual).to eq(1)
    end
    it 'returns -1 if second argument is nil' do
      actual = model.send(:handle_nil, :foo, nil)
      expect(actual).to eq(-1)
    end
  end

  describe '#compare' do
    let(:first_arg)  { 'foo' }
    let(:second_arg) { 'bar' }

    context 'when direction is "desc"' do
      it 'compares 2nd argument with 1st argument' do
        expect(second_arg).to receive(:<=>).with(first_arg)
        model.send(:compare, first_arg, second_arg, 'desc')
      end
    end
    context 'when direction is NOT "desc"' do
      it 'compares 1st argument with 2nd argument' do
        expect(first_arg).to receive(:<=>).with(second_arg)
        model.send(:compare, first_arg, second_arg, 'foo')
      end
    end
  end
end
