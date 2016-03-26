require 'rails_helper'

describe UserDecorator do
  let(:user_decorator) { build(:user).decorate }

  it 'the subject is decorated' do
    expect(user_decorator).to be_decorated
  end

  describe '#account?' do
    let(:type)    { 'type' }
    let(:account) { 'account' }

    before(:each) do
      allow(user_decorator).to receive(:type).and_return(type)
      allow(user_decorator).to receive(:account).and_return(account)
    end
    after(:each) do
      user_decorator.account?
    end

    it 'calls #type' do
      expect(user_decorator).to receive(:type)
    end

    it 'calls #account' do
      expect(user_decorator).to receive(:account)
    end

    it 'type is compared to account' do
      expect(type).to receive(:==).with(account)
    end
  end

  describe '#account' do
    it 'returns name of Users::Account class as a string' do
      expected = 'Users::Account'
      expect(user_decorator.send(:account)).to eq expected
    end
  end
end
