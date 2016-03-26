require 'rails_helper'

describe NoteDecorator do
  let(:note_decorator) { build(:note).decorate }
  let(:helper) { double('helper') }

  it 'the subject is decorated' do
    expect(note_decorator).to be_decorated
  end

  describe '#link_destination' do
    before(:each) do
      allow(note_decorator).to receive(:notable_id).and_return(1)
    end
    after(:each) do
      note_decorator.link_destination
    end

    context 'when notable_type is Contact' do
      before(:each) do
        allow(note_decorator).to receive(:contact_type?).and_return(true)
      end

      it 'calls #contact_path' do
        expect(note_decorator).to receive(:contact_path)
      end
    end

    context 'when notable_type is JobApplication' do
      before(:each) do
        allow(note_decorator).to receive(:contact_type?).and_return(false)
        allow(note_decorator).to receive(:job_application_type?).and_return(true)
      end

      it 'calls #job_application_path' do
        expect(note_decorator).to receive(:job_application_path)
      end
    end
  end

  describe '#notable_name' do
    after(:each) do
      note_decorator.notable_name
    end

    context 'when notable_type is Contact' do
      let(:notable) { build(:contact) }

      before(:each) do
        allow(note_decorator).to receive(:contact_type?).and_return(true)
        allow(note_decorator).to receive(:notable).and_return(notable)
        allow(notable).to receive(:name).and_return('Foo Bar')
      end

      it 'calls #name on the notable object' do
        expect(notable).to receive(:name)
      end
      it 'returns name of the contact' do
        expect(note_decorator.notable_name).to eq 'Foo Bar'
      end
    end

    context 'when notable_type is JobApplication' do
      let(:notable) { build(:job_application) }
      let(:title) { 'Assistant to the Traveling Secretary - New York Yankees' }

      before(:each) do
        allow(note_decorator).to receive(:contact_type?).and_return(false)
        allow(note_decorator).to receive(:job_application_type?).and_return(true)
        allow(note_decorator).to receive(:notable).and_return(notable)
        allow(notable).to receive(:title).and_return(title)
      end

      it 'calls #title on the notable object' do
        expect(notable).to receive(:title)
      end
      it 'returns name of the contact' do
        expect(note_decorator.notable_name).to eq title
      end
    end
  end

  describe '#contact_type?' do
    context 'when notable_type is Contact' do
      before(:each) do
        allow(note_decorator).to receive(:notable_type).and_return('Contact')
      end

      it 'returns true' do
        actual = note_decorator.send(:contact_type?)
        expect(actual).to be_truthy
      end
    end

    context 'when notable_type NOT is Contact' do
      before(:each) do
        allow(note_decorator).to receive(:notable_type).and_return('FOO')
      end

      it 'returns false' do
        actual = note_decorator.send(:contact_type?)
        expect(actual).to be_falsey
      end
    end
  end

  describe '#job_application_type?' do
    context 'when notable_type is JobApplication' do
      before(:each) do
        allow(note_decorator).to receive(:notable_type).and_return('JobApplication')
      end

      it 'returns true' do
        actual = note_decorator.send(:job_application_type?)
        expect(actual).to be_truthy
      end
    end

    context 'when notable_type NOT is JobApplication' do
      before(:each) do
        allow(note_decorator).to receive(:notable_type).and_return('BAR')
      end

      it 'returns false' do
        actual = note_decorator.send(:job_application_type?)
        expect(actual).to be_falsey
      end
    end
  end

  describe '#contact_path' do
    before(:each) do
      allow(note_decorator).to receive(:h).and_return(helper)
      allow(note_decorator).to receive(:notable_id).and_return(1)
      allow(helper).to receive(:contact_path)
    end
    after(:each) do
      note_decorator.send(:contact_path)
    end

    it 'calls contact_path' do
      expect(helper).to receive(:contact_path).with(1)
    end
  end

  describe '#job_application_path' do
    before(:each) do
      allow(note_decorator).to receive(:h).and_return(helper)
      allow(note_decorator).to receive(:notable_id).and_return(1)
      allow(helper).to receive(:job_application_path)
    end
    after(:each) do
      note_decorator.send(:job_application_path)
    end

    it 'calls job_application_path' do
      expect(helper).to receive(:job_application_path).with(1)
    end
  end
end
