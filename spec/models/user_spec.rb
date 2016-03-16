require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#account?' do
    let(:type)    { 'type' }
    let(:account) { 'account' }

    before(:each) do
      allow(user).to receive(:type).and_return(type)
      allow(user).to receive(:account).and_return(account)
    end
    after(:each) do
      user.account?
    end

    it 'calls #type' do
      expect(user).to receive(:type)
    end

    it 'calls #account' do
      expect(user).to receive(:account)
    end

    it 'type is compared to account' do
      expect(type).to receive(:==).with(account)
    end
  end

  describe '#account' do
    it 'returns name of Users::Account class as a string' do
      expected = 'Users::Account'
      expect(user.send(:account)).to eq expected
    end
  end

  describe '#add_type_error' do
    before(:each) do
      allow(user).to receive(:account).and_return('account')
    end
    after(:each) do
      user.errors.clear
    end

    it 'calls #account' do
      expect(user).to receive(:account)
      user.send(:add_type_error)
    end
    it 'adds an error to the :type attribute' do
      user.send(:add_type_error)
      actual = user.errors[:type].any?
      expect(actual).to be_truthy
    end
  end
end
