require 'rails_helper'

describe Users::OmniAuthUser, type: :model do
  let(:omni_auth_user) { build(:omni_auth_user) }

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
    it 'calls .first on the relation' do
      expect(relation).to receive(:first)
      described_class.find_from_omni_auth(auth)
    end
    it 'returns the first item from relation' do
      actual = described_class.find_from_omni_auth(auth)
      expect(actual).to eq :foo
    end
  end

  describe '.create_from_omni_auth!' do
    let(:auth) { :auth }
    let(:params) { :params }

    before(:each) do
      allow(described_class).to receive(:extract_params).and_return(params)
      allow(described_class).to receive(:create!).and_return(omni_auth_user)
    end
    after(:each) do
      described_class.create_from_omni_auth!(auth)
    end

    it 'calls .extract_params' do
      expect(described_class).to receive(:extract_params).with(auth)
    end
    it 'calls .create! on Users::OmniAuthUser' do
      expect(described_class).to receive(:create!).with(params)
    end
  end

  describe '.extract_params' do
    let(:auth) do
      {
        'provider' => 'developer',
        'uid'      => '12345',
        'info'     => { 'name' => 'Foo Bar' }
      }
    end

    it 'extracts the "provider", "uid" and "name" keys from passed-in hash' do
      actual = described_class.send(:extract_params, auth)
      expected = { provider: 'developer', uid: '12345', name: 'Foo Bar' }
      expect(actual).to eq expected
    end
  end
end
