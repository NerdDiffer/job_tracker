require 'rails_helper'

describe Category, type: :model do
  let(:category) { build(:category) }

  describe '#display_name' do
    before(:each) do
      allow(category).to receive(:name).and_return('foo bar optimization')
    end

    it 'titleizes the name' do
      actual = category.display_name
      expect(actual).to eq 'Foo Bar Optimization'
    end
  end
end
