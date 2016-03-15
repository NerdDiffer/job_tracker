require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)     { build(:user) }
  let(:identity) { build(:identity) }
  let(:identifiable) { double('identifiable') }

  it 'needs an identity to be valid' do
    allow(user).to receive(:identity).and_return(identity)
    expect(user).to be_valid
  end

  describe '#identifiable' do
    before(:each) do
      allow(user).to receive(:identity).and_return(identity)
      allow(identity).to receive(:identifiable)
    end
    after(:each) do
      user.identifiable
    end

    it 'calls #identity' do
      expect(user).to receive(:identity)
    end
    it 'calls #identifiable on identity' do
      expect(identity).to receive(:identifiable)
    end
  end

  describe '#identifiable_account?' do
    let(:account_class_name) { 'Foo' }
    let(:dummy_class)  { 'Dummy' }

    before(:each) do
      allow(user).to receive(:identifiable).and_return(identifiable)
      allow(identifiable).to receive(:class).and_return(dummy_class)
      allow(user)
        .to receive(:account_class_name)
        .and_return(account_class_name)
    end
    after(:each) do
      user.identifiable_account?
    end

    it 'calls #class on identifiable' do
      expect(identifiable).to receive(:class)
    end
    it 'calls :== on identifiable.class' do
      expect(dummy_class).to receive(:==).with(account_class_name)
    end
  end

  describe '#identifiable_provider_identity?' do
    let(:provider_identity_class_name) { 'Foo' }
    let(:dummy_class)  { 'Dummy' }

    before(:each) do
      allow(user).to receive(:identifiable).and_return(identifiable)
      allow(identifiable).to receive(:class).and_return(dummy_class)
      allow(user)
        .to receive(:provider_identity_class_name)
        .and_return(provider_identity_class_name)
    end
    after(:each) do
      user.identifiable_provider_identity?
    end

    it 'calls #class on identifiable' do
      expect(identifiable).to receive(:class)
    end
    it 'calls :== on identifiable.class' do
      expect(dummy_class).to receive(:==).with(provider_identity_class_name)
    end
  end

  describe '#remember' do
    before(:each) do
      allow(user).to receive(:identifiable_account?).and_return(true)
      allow(identifiable).to receive(:remember)
      allow(user).to receive(:identifiable).and_return(identifiable)
    end
    after(:each) do
      user.remember
    end

    it 'calls #identifiable_account?' do
      expect(user).to receive(:identifiable_account?)
    end
    it 'calls #identifiable' do
      expect(user).to receive(:identifiable)
    end
    it 'calls #remember on identifiable' do
      expect(identifiable).to receive(:remember)
    end
  end

  describe '#forget' do
    before(:each) do
      allow(user).to receive(:identifiable_account?).and_return(true)
      allow(identifiable).to receive(:forget)
      allow(user).to receive(:identifiable).and_return(identifiable)
    end
    after(:each) do
      user.forget
    end

    it 'calls #identifiable_account?' do
      expect(user).to receive(:identifiable_account?)
    end
    it 'calls #identifiable' do
      expect(user).to receive(:identifiable)
    end
    it 'calls #forget on identifiable' do
      expect(identifiable).to receive(:forget)
    end
  end

  describe '#remember_token' do
    before(:each) do
      allow(user).to receive(:identifiable_account?).and_return(true)
      allow(identifiable).to receive(:remember_token)
      allow(user).to receive(:identifiable).and_return(identifiable)
    end
    after(:each) do
      user.remember_token
    end

    it 'calls #identifiable_account?' do
      expect(user).to receive(:identifiable_account?)
    end
    it 'calls #identifiable' do
      expect(user).to receive(:identifiable)
    end
    it 'calls #remember_token on identifiable' do
      expect(identifiable).to receive(:remember_token)
    end
  end

  describe '#authenticate' do
    before(:each) do
      allow(user).to receive(:identifiable_account?).and_return(true)
      allow(identifiable).to receive(:authenticate)
      allow(user).to receive(:identifiable).and_return(identifiable)
    end
    after(:each) do
      user.authenticate(:foo)
    end

    it 'calls #identifiable_account?' do
      expect(user).to receive(:identifiable_account?)
    end
    it 'calls #identifiable' do
      expect(user).to receive(:identifiable)
    end
    it 'calls #authenticate on identifiable' do
      expect(identifiable).to receive(:authenticate).with(:foo)
    end
  end

  describe '#authenticated?' do
    context 'if #identifiable_account? is false' do
      before(:each) do
        allow(user).to receive(:identifiable_account?).and_return(false)
      end

      it 'calls #identifiable_account?' do
        expect(user).to receive(:identifiable_account?)
        user.authenticated?('foo', 'bar')
      end
      it 'does NOT call #identifiable' do
        expect(user).not_to receive(:identifiable)
        user.authenticated?('foo', 'bar')
      end
      it 'returns nil' do
        expect(user.authenticated?('foo', 'bar')).to be_nil
      end
    end
    context 'if #identifiable_account? is true' do
      before(:each) do
        allow(user).to receive(:identifiable_account?).and_return(true)
        allow(identifiable).to receive(:authenticated?).and_return(true)
        allow(user).to receive(:identifiable).and_return(identifiable)
      end

      it 'calls #identifiable_account' do
        expect(user).to receive(:identifiable_account?)
        user.authenticated?('foo', 'bar')
      end
      it 'calls #identifiable' do
        expect(user).to receive(:identifiable)
        user.authenticated?('foo', 'bar')
      end
      it 'returns a truthy value' do
        expect(user.authenticated?('foo', 'bar')).to be_truthy
      end
    end
  end

  describe '#account_class_name' do
    it 'returns name of account class as a string' do
      actual = user.send(:account_class_name)
      expect(actual).to eq 'Users::Account'
    end
  end

  describe '#provider_identity_class_name' do
    it 'returns name of provider_identity class as a string' do
      actual = user.send(:provider_identity_class_name)
      expect(actual).to eq 'Users::ProviderIdentity'
    end
  end
end
