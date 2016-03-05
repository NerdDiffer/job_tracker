require 'rails_helper'

describe Source, type: :model do
  let(:source) { build(:source) }

  describe '#display_name' do
    before(:each) do
      allow(source).to receive(:name).and_return('foo_bar')
    end

    it 'camelizes the name' do
      actual = source.display_name
      expect(actual).to eq 'FooBar'
    end
  end
end
