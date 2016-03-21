require 'rails_helper'

describe Note, type: :model do
  let(:note) { build(:note) }
  let(:dummy) { double('dummy') }

  describe '#notable_name' do
    context 'when note has notable_type of Contact' do
      before(:each) do
        allow(dummy).to receive(:class).and_return(Contact)
        allow(dummy).to receive(:id).and_return(1)
        allow(dummy).to receive(:name).and_return('Joe Schmoe')
        allow(Contact).to receive(:find).and_return(dummy)
        allow(note).to receive(:notable_type).and_return(dummy.class)
        allow(note).to receive(:notable).and_return(dummy)
        allow(Note).to receive(:find).and_return(note)
      end

      it 'returns name of the contact' do
        expect(note.notable_name).to eq 'Joe Schmoe'
      end
    end

    context 'when note has notable_type of JobApplication' do
      before(:each) do
        allow(dummy).to receive(:class).and_return(JobApplication)
        allow(dummy).to receive(:id).and_return(1)
        allow(dummy).to receive(:title).and_return('Assistant to the Traveling Secretary - New York Yankees')
        allow(JobApplication).to receive(:find).and_return(dummy)
        allow(note).to receive(:notable_type).and_return(dummy.class)
        allow(note).to receive(:notable).and_return(dummy)
        allow(Note).to receive(:find).and_return(note)
      end

      it 'returns job title of the job application' do
        expect(note.notable_name).to eq 'Assistant to the Traveling Secretary - New York Yankees'
      end
    end
  end
end
