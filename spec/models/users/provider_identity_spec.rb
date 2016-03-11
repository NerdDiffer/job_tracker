require 'rails_helper'

describe Users::ProviderIdentity, type: :model do
  let(:user)         { build(:user) }
  let(:identity)     { build(:identity) }
  let(:provider_id)  { build(:provider_identity) }

  describe '.find_from_omni_auth' do
    let(:auth) { :auth }
    let(:relation) { %I(foo bar) }

    before(:each) do
      allow(described_class).to receive(:extract_params).and_return('params')
      allow(described_class).to receive(:where).and_return(relation)
    end

    it 'calls .extract_params' do
      expect(described_class).to receive(:extract_params).with(auth)
      described_class.find_from_omni_auth(auth)
    end
    it 'calls .where' do
      expect(described_class).to receive(:where).with('params')
      described_class.find_from_omni_auth(auth)
    end
    it 'returns the first item from relation' do
      actual = described_class.find_from_omni_auth(auth)
      expect(actual).to eq :foo
    end
  end

  describe '.create_from_omni_auth' do
    let(:auth) { :auth }

    before(:each) do
      allow(described_class).to receive(:extract_params).and_return('params')
      allow(Users::Identity).to receive(:new).and_return(identity)
      allow(User).to receive(:new).and_return(user)
      allow(described_class).to receive(:new).and_return(provider_id)
      allow(described_class).to receive(:assign_user_identities)
      allow(described_class).to receive(:save_user_identities!)
    end

    context 'expected method calls' do
      after(:each) do
        described_class.create_from_omni_auth(auth)
      end

      it 'calls .extract_params' do
        expect(described_class).to receive(:extract_params).with(auth)
      end
      it 'calls .new on Users::Identity' do
        expect(Users::Identity).to receive(:new)
      end
      it 'calls .new on User' do
        expect(User).to receive(:new)
      end
      it 'calls .new on Users::ProviderIdentity' do
        expect(described_class).to receive(:new).with('params')
      end
      it 'calls .assign_user_identities' do
        expect(described_class)
          .to receive(:assign_user_identities)
          .with(provider_id, identity, user)
      end
      it 'calls .save_user_identities!' do
        expect(described_class)
          .to receive(:save_user_identities!)
          .with(provider_id, identity, user)
      end
    end

    context 'when .save_user_identities! is false' do
      before(:each) do
        allow(described_class)
          .to receive(:save_user_identities!)
          .and_return(true)
      end

      it 'returns a Users::ProviderIdentity object' do
        actual = described_class.create_from_omni_auth(auth)
        expect(actual).to be_a Users::ProviderIdentity
      end
    end

    context 'when .save_user_identities! is false' do
      before(:each) do
        allow(described_class)
          .to receive(:save_user_identities!)
          .and_return(false)
      end

      it 'returns nil' do
        expect(described_class.create_from_omni_auth(auth)).to be_nil
      end
    end
  end

  describe '.extract_params' do
    let(:auth) do
      { 'provider' => 'developer', 'uid' => '12345' }
    end

    it 'extracts the "provider" and "uid" keys from passed-in hash' do
      actual = described_class.send(:extract_params, auth)
      expected = { provider: 'developer', uid: '12345' }
      expect(actual).to eq expected
    end
  end

  describe '.assign_user_identities' do
    it 'sets provider_id.identity to identity' do
      expect { described_class.send(:assign_user_identities, provider_id, identity, user) }
       .to change { provider_id.identity }
       .from(nil)
       .to(identity)
    end
    it 'sets identity.identifiable to provider_id' do
      expect { described_class.send(:assign_user_identities, provider_id, identity, user) }
        .to change { identity.identifiable }
        .from(nil)
        .to(provider_id)
    end
    it 'sets identity.user to user' do
      expect { described_class.send(:assign_user_identities, provider_id, identity, user) }
        .to change { identity.user }
        .from(nil)
        .to(user)
    end
    it 'sets user.identity to identity' do
      expect { described_class.send(:assign_user_identities, provider_id, identity, user) }
        .to change { user.identity }
        .from(nil)
        .to(identity)
    end
  end

  describe '.save_user_identities!' do
    context 'the happy path' do
      before(:each) do
        allow(provider_id).to receive(:save).and_return(true)
        allow(identity).to receive(:save).and_return(true)
        allow(user).to receive(:save).and_return(true)
      end

      it 'calls #save on provider_id' do
        expect(provider_id).to receive(:save)
        described_class.send(:save_user_identities!, provider_id, identity, user)
      end
      it 'calls #save on identity' do
        expect(identity).to receive(:save)
        described_class.send(:save_user_identities!, provider_id, identity, user)
      end
      it 'calls #save on user' do
        expect(user).to receive(:save)
        described_class.send(:save_user_identities!, provider_id, identity, user)
      end
      it 'returns a truthy value' do
        actual = described_class.send(:save_user_identities!, provider_id,
                                      identity, user)
        expect(actual).to be_truthy
      end
    end
  end

  describe '#user' do
    before(:each) do
      allow(provider_id).to receive(:identity).and_return(identity)
      allow(identity).to receive(:user).and_return(user)
    end
    after(:each) do
      provider_id.user
    end

    it 'calls #identity' do
      expect(provider_id).to receive(:identity)
    end
    it 'calls #user on identity' do
      expect(identity).to receive(:user)
    end
  end
end
