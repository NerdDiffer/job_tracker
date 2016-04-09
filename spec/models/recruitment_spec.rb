require 'rails_helper'

describe Recruitment, type: :model do
  let(:recruitment) { build(:recruitment) }
  let(:agency) { build(:company) }
  let(:client) { build(:company) }
  let(:recruit) { build(:user) }

  describe '#client_name' do
    context 'when a client is present' do
      before(:each) do
        allow(recruitment).to receive(:client_id?).and_return(true)
        allow(recruitment).to receive(:client).and_return(client)
        allow(client).to receive(:name).and_return('Client')
      end

      it 'returns the name of the client' do
        actual = recruitment.client_name
        expect(actual).to eq 'Client'
      end
    end

    context 'when a client is NOT present' do
      before(:each) do
        allow(recruitment).to receive(:client_id?).and_return(false)
      end

      it 'returns nil' do
        actual = recruitment.client_name
        expect(actual).to be_nil
      end
    end
  end

  describe '#agency_name' do
    context 'when agency is present' do
      before(:each) do
        allow(recruitment).to receive(:agency_id?).and_return(true)
        allow(recruitment).to receive(:agency).and_return(agency)
        allow(agency).to receive(:name).and_return('Agency')
      end

      it 'returns the name of the agency' do
        actual = recruitment.agency_name
        expect(actual).to eq 'Agency'
      end
    end

    context 'when agency is NOT present' do
      before(:each) do
        allow(recruitment).to receive(:agency_id?).and_return(false)
      end

      it 'returns nil' do
        actual = recruitment.agency_name
        expect(actual).to be_nil
      end
    end
  end

  describe '#validate_agency_category' do
    before(:each) do
      allow(recruitment).to receive(:agency).and_return(agency)
      allow(recruitment).to receive(:client).and_return(client)
      allow(recruitment).to receive(:recruit).and_return(recruit)
    end

    context 'when company in the agency spot is actually an agency' do
      before(:each) do
        allow(recruitment).to receive(:recruiting_agency?).and_return(true)
      end

      it 'does NOT have any errors' do
        expect(recruitment.valid?).to be_truthy
      end
    end

    context 'when company in the agency spot is NOT actually an agency' do
      before(:each) do
        allow(recruitment).to receive(:recruiting_agency?).and_return(false)
        recruitment.valid?
      end

      it 'adds an error to the :agency attribute' do
        actual = recruitment.errors[:agency]
        expect(actual).not_to be_nil
      end
    end
  end

  describe '#recruiting_agency?' do
    before(:each) do
      allow(recruitment).to receive(:agency).and_return(agency)
    end

    context 'when company in the agency spot is actually an agency' do
      before(:each) do
        allow(agency).to receive(:agency?).and_return(true)
      end

      it 'returns true' do
        actual = recruitment.send(:recruiting_agency?)
        expect(actual).to be_truthy
      end
    end

    context 'when company in the agency spot is NOT actually an agency' do
      before(:each) do
        allow(agency).to receive(:agency?).and_return(false)
      end

      it 'returns false' do
        actual = recruitment.send(:recruiting_agency?)
        expect(actual).to be_falsey
      end
    end
  end
end
