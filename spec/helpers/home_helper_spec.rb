require 'rails_helper'

describe HomeHelper, type: :helper do
  describe '#target_blank' do
    it 'returns this hash' do
      expected = { target: '_blank' }
      expect(helper.target_blank).to eq expected
    end
  end
end
