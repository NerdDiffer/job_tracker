require 'rails_helper'

describe Users::Account, type: :model do
  let(:account) { build(:account) }

  describe '#validate_type' do
    it 'calls #account?' do
      allow(account).to receive(:account?)
      expect(account).to receive(:account?)
      account.send(:validate_type)
    end

    context 'if #account? is false' do
      before(:each) do
        allow(account).to receive(:account?).and_return(false)
        allow(account).to receive(:add_type_error)
      end

      it 'calls #add_type_error' do
        expect(account).to receive(:add_type_error)
        account.send(:validate_type)
      end
    end

    context 'if #account? is true' do
      before(:each) do
        allow(account).to receive(:account?).and_return(true)
        account.send(:validate_type)
      end

      it 'does NOT call #add_type_error' do
        expect(account).not_to receive(:add_type_error)
        account.send(:validate_type)
      end
    end
  end
end
