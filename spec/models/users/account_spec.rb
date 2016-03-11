require 'rails_helper'

describe Users::Account, type: :model do
  let(:user)     { build(:user) }
  let(:identity) { build(:identity) }
  let(:account)  { build(:account) }

  describe '.assign_and_save_user_identities!' do
    before(:each) do
      allow(described_class).to receive(:assign_user_identities)
      allow(described_class).to receive(:save_user_identities!)
    end
    after(:each) do
      described_class.assign_and_save_user_identities!(account, identity, user)
    end

    it 'calls .assign_user_identities' do
      expect(described_class)
        .to receive(:assign_user_identities)
        .with(account, identity, user)
    end
    it 'calls .save_user_identities!' do
      expect(described_class)
        .to receive(:save_user_identities!)
        .with(account, identity, user)
    end
  end

  describe '.assign_user_identities' do
    it 'sets account.identity to identity' do
      expect { described_class.send(:assign_user_identities, account, identity, user) }
       .to change { account.identity }
       .from(nil)
       .to(identity)
    end
    it 'sets identity.identifiable to account' do
      expect { described_class.send(:assign_user_identities, account, identity, user) }
        .to change { identity.identifiable }
        .from(nil)
        .to(account)
    end
    it 'sets identity.user to user' do
      expect { described_class.send(:assign_user_identities, account, identity, user) }
        .to change { identity.user }
        .from(nil)
        .to(user)
    end
    it 'sets user.identity to identity' do
      expect { described_class.send(:assign_user_identities, account, identity, user) }
        .to change { user.identity }
        .from(nil)
        .to(identity)
    end
  end

  describe '.save_user_identities!' do
    context 'the happy path' do
      before(:each) do
        allow(account).to receive(:save).and_return(true)
        allow(identity).to receive(:save).and_return(true)
        allow(user).to receive(:save).and_return(true)
      end

      it 'calls #save on account' do
        expect(account).to receive(:save)
        described_class.send(:save_user_identities!, account, identity, user)
      end
      it 'calls #save on identity' do
        expect(identity).to receive(:save)
        described_class.send(:save_user_identities!, account, identity, user)
      end
      it 'calls #save on user' do
        expect(user).to receive(:save)
        described_class.send(:save_user_identities!, account, identity, user)
      end
      it 'returns a truthy value' do
        actual = described_class.send(:save_user_identities!, account,
                                      identity, user)
        expect(actual).to be_truthy
      end
    end
  end

  describe '#user' do
    before(:each) do
      allow(account).to receive(:identity).and_return(identity)
      allow(identity).to receive(:user).and_return(user)
    end
    after(:each) do
      account.user
    end

    it 'calls #identity' do
      expect(account).to receive(:identity)
    end
    it 'calls #user on identity' do
      expect(identity).to receive(:user)
    end
  end
end
