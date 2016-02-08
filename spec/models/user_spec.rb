require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'one model' do
    it 'is valid' do
      expect(user).to be_valid
    end
  end
end
