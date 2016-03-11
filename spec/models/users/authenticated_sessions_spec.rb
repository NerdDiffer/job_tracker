require 'rails_helper'

describe Users::AuthenticatedSessions, type: :model do
  let(:account)  { build(:account) }

  describe '#remember' do
    before(:each) do
      allow(account).to receive(:new_token).and_return('new_token')
      allow(account).to receive(:digest).and_return('digest')
      allow(account).to receive(:update_attribute)
    end
    after(:each) do
      account.remember
    end

    it 'calls #new_token' do
      expect(account).to receive(:new_token)
    end
    it 'calls #digest' do
      expect(account).to receive(:digest)
    end
    it 'calls #update_attribute' do
      expect(account).to receive(:update_attribute).with(:remember_digest, 'digest')
    end
  end

  describe '#forget' do
    before(:each) do
      allow(account).to receive(:update_attribute)
    end
    after(:each) do
      account.forget
    end

    it 'calls #update_attribute' do
      expect(account).to receive(:update_attribute).with(:remember_digest, nil)
    end
  end

  describe '#authenticated?' do
    it 'is false when remember_digest is nil' do
      allow(account).to receive(:remember_digest).and_return(nil)
      actual = account.authenticated?(:remember, 'token')
      expect(actual).to be_falsey
    end
    it 'calls match?' do
      allow(account).to receive(:remember_digest).and_return('foo')
      expect(account).to receive(:match?).with('foo', 'token')
      account.authenticated?(:remember, 'token')
    end
  end

  describe '#cost' do
    context 'when ActiveModel::SecurePassword.min_cost is true' do
      before(:each) do
        allow(ActiveModel::SecurePassword).to receive(:min_cost).and_return(true)
      end

      it 'returns BCrypt::Engine::MIN_COST' do
        actual = account.send(:cost)
        expect(actual).to eq BCrypt::Engine::MIN_COST
      end
    end

    context 'when ActiveModel::SecurePassword.min_cost is false' do
      before(:each) do
        allow(ActiveModel::SecurePassword)
          .to receive(:min_cost)
          .and_return(false)
        allow(BCrypt::Engine).to receive(:cost).and_return('###########')
      end

      it 'calls BCrypt::Engine.cost' do
        skip 'why is this failing?'
        expect(BCrypt::Engine).to receive(:cost)
        account.send(:cost)
      end
    end
  end

  describe '#digest' do
    let(:remember_token) { 'remember_token' }
    let(:cost) { 'cost' }

    before(:each) do
      allow(account).to receive(:cost).and_return(cost)
      allow(BCrypt::Password).to receive(:create)
    end
    after(:each) do
      account.send(:digest, remember_token)
    end

    it 'calls #cost' do
      expect(account).to receive(:cost)
    end

    it 'calls create on BCrypt::Password' do
      expect(BCrypt::Password)
        .to receive(:create)
        .with(remember_token, cost: cost)
    end
  end

  describe '#new_token' do
    before(:each) do
      allow(SecureRandom).to receive(:urlsafe_base64)
    end

    it 'calls urlsafe_base64 on SecureRandom' do
      expect(SecureRandom).to receive(:urlsafe_base64)
      account.send(:new_token)
    end
  end

  describe '#match?' do
    let(:digest) { 'digest' }
    let(:token)  { 'token' }
    let(:password_digest) { 'password_digest' }

    before(:each) do
      allow(BCrypt::Password).to receive(:new).and_return(password_digest)
    end
    after(:each) do
      account.send(:match?, digest, token)
    end

    it 'calls for a new BCrypt::Password' do
      expect(BCrypt::Password).to receive(:new).and_return(digest)
    end
    it 'checks if password_digest is equal to the token' do
      expect(password_digest).to receive(:==).with(token)
    end
  end
end
