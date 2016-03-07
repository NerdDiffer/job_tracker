require 'rails_helper'

describe NotesHelper, type: :helper do
  let(:note) { build(:note, notable_id: 1) }

  describe '#generate_notable_link_dest' do
    after(:each) do
      helper.generate_notable_link_dest(note)
    end

    context 'when note.notable_type is Contact' do
      it 'calls #contact_path' do
        allow(note).to receive(:notable_type).and_return('Contact')
        expect(helper).to receive(:contact_path).with(1)
      end
    end
    context 'when note.notable_type is JobApplication' do
      it 'calls #job_application_path' do
        allow(note).to receive(:notable_type).and_return('JobApplication')
        expect(helper).to receive(:job_application_path).with(1)
      end
    end
  end
end
